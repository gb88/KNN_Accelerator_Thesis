#include "mex.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdarg.h>
#include <math.h>
#include <sys/types.h>
#include "lusb0_usb.h"
#if !defined(_WIN32) || defined(__CYGWIN__ )
#include <syslog.h>
static bool dosyslog = false;
#include <strings.h>
#define _stricmp strcasecmp
#endif

#define DEV_LIST_MAX 128
#define ALTERA_VID 0x09FB
#define USB_BLASTER_PID 0x6001
#define FLUSH_COMM 0x0101
#define CLASS_CMD 0xA1A1
#define USB_TIMEOUT 1000
#define ACK 0xAA55


void logerror(const char *format, ...)
{
	va_list ap;
    va_start(ap, format);
    vfprintf(stderr, format, ap);
    va_end(ap);
};
//function to get the FPGA4U connected to the PC
usb_dev_handle *get_usb_device() 
{
	struct usb_bus *bus;
	struct usb_device *dev;
	struct usb_device *devlist[DEV_LIST_MAX];
	usb_dev_handle *dev_h = NULL;
	int index = 0;
	int sel = -1; 
	int i;
	for(i=0;i<DEV_LIST_MAX;i++)
		devlist[i] = NULL;
	usb_init();
	usb_set_debug(0);
	usb_find_busses();
	usb_find_devices();
	for (bus = usb_get_busses(); bus; bus = bus->next)
	{
		for (dev = bus->devices; dev; dev = dev->next)
		{
			if(dev->descriptor.idVendor == ALTERA_VID && dev->descriptor.idProduct == USB_BLASTER_PID)
			sel = index;
			if(index < DEV_LIST_MAX)
				devlist[index] = dev;
			index++;
		}
	}
	fflush(NULL);
	if( sel < 0 || devlist[sel] == NULL )
	{
		logerror("No FPGA4U connected!\n");
		return NULL;
	}  
	dev_h = usb_open(devlist[sel]);
	return dev_h;
}
//function for the bulk write of byte_num byte in the USB port
int send_to_usb(usb_dev_handle	*device, unsigned short *buffer, int byte_num)
{
	int w = usb_bulk_write(device, 6, (char*)buffer, byte_num, USB_TIMEOUT);
	if (w  < 0)
	{
		printf("Error on write : %s\n", usb_strerror());
		exit(1);
	}
	return w;
}
//function for the bulk read of the ACK from the USB port
int recv_ack(usb_dev_handle	*device, unsigned short *buffer, int byte_num)
{
	int r = usb_bulk_read(device, 0x88, (char*)buffer, byte_num, USB_TIMEOUT);
	if(r < 0 || buffer[0]!=ACK || buffer[1]!=ACK ) 
	{
		printf("Error on read : %s\n", usb_strerror());
		exit(1);
	}
	return r;
}
//function for the bulk read of byte_num byte from the USB port
void recv_from_usb(usb_dev_handle *device, unsigned short *buffer, int byte_num)
{
	int r = usb_bulk_read(device, 0x88, (char*)buffer, byte_num, 3000);
	if(r < 0) 
	{
		printf("Error on read : %s\n", usb_strerror());
		exit(1);
	}
	return;
}
//function to send the vector to classify the data are read from a file created by matlab
void classifier(usb_dev_handle* device,unsigned int size, unsigned int window)
{
	FILE * pFile;
    int r;
	pFile = fopen ("query.dat","r");
	if (pFile==NULL)
	{
		printf("Error on open file query.dat\n");
		exit(1);	
	}
	else
	{
		int i = 0;
		int hexval;
		unsigned short shortval;
		unsigned short command[256];
		fseek(pFile, size*9, SEEK_SET); // set the position in the file
		for (i = 0; i < window; i++)
		{
			fscanf(pFile,"%x",&hexval);
			shortval = hexval>>16;
			//most significant part
			command[2*i] = shortval;
			//least significant part
			shortval = hexval;
			command[1+2*i] = shortval;
		}
		send_to_usb(device,command, 512);
		r = usb_bulk_read(device, 0x88, (char*)command, 512, 1000);
		if(r < 0 )
		{
			printf("Error on read : %s\n", usb_strerror());
		}
		fclose(pFile);
	}
}

//function for the initialization of the USB port
void init_usb(usb_dev_handle *device)
{
	if (device == NULL) exit(1);
	usb_set_configuration(device, 1);
	if(usb_claim_interface(device, 0) < 0)
	{
		printf("Error when claiming interface!");
		exit(1);
	}
	if (device == NULL) 
	{
		logerror("No device to configure\n");
		exit(1);
	}
	return;
}
//function to close the USB port
void close_usb(usb_dev_handle *device)
{
	usb_reset(device);
	usb_release_interface(device, 0);
    usb_close(device);
	return;
}
//mexFunction for matlab
void mexFunction(int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[]) 
{
	unsigned short command[256];
	unsigned short tab[512];
    unsigned int q_row = 0;
	unsigned long long int perf_count = 0;
	unsigned long long int  time;
	float n_loc = 0.0;
	float base_addr = 0.0;
	float n_dim = 0.0;
    unsigned int tb_size;
	float n_tr = 0.0;
	unsigned int dim_1 = 0;
	unsigned int dim_last = 0;
	unsigned int n_load = 0;
    unsigned short* data;
    unsigned int memword = 0;
    unsigned short kval = 0;
    unsigned short parallelism = 0;
	int i;
    int j;
	int w;
	int r;
	usb_dev_handle	*device;
	//read the values from matlab
    n_dim = (float)mxGetScalar(prhs[0]);
    n_tr = (float)mxGetScalar(prhs[1]);
    q_row = (unsigned int)mxGetScalar(prhs[2]);
    tb_size = (unsigned int)mxGetScalar(prhs[3]);
    kval = (unsigned short)mxGetScalar(prhs[4]);
    parallelism = (unsigned short)mxGetScalar(prhs[5]);
    memword =  (unsigned int)mxGetScalar(prhs[6]);
	//number of row of memory used for the query data
	n_loc = (ceil(n_dim/3)+1);
	//start address of the query data
	base_addr = (memword -(n_loc-1))*4;
	//check how many memory transfers are needed
	if(n_loc*n_tr <= base_addr*parallelism/4)
	{
		//the dimension of the first parallelism-1 block is the same and equal to dim_1 while the last is dim_last
		//in this case only parallelism transfer are needed
		dim_1 = ceil(n_loc*n_tr/parallelism);
		printf("standard dim %d \n",dim_1);
		dim_1 = dim_1 - (dim_1% (int)n_loc);
		printf("standard dim %d \n",dim_1);
		dim_1 = 4*dim_1;
		printf("standard dim %d \n",dim_1);
		n_load = parallelism;
		if((n_loc*n_tr*4-dim_1*(parallelism-1)) != 0)
			dim_last = n_loc*n_tr*4-dim_1*(parallelism-1);
		else
			dim_last = dim_1;
	}
	else
	{
		//more transfer are needed
		dim_1 =  ((int)n_loc*4)*floor((int) base_addr/((int)n_loc*4));
		n_load = ceil(n_loc*n_tr*4/(int)dim_1);
		if((int)((int)(n_loc*n_tr*4) % (int)dim_1) != 0)
			dim_last = (int)((int)(n_loc*n_tr*4) % (int)dim_1);
		else
			dim_last = dim_1;
		
	}
	for(i = 0; i < 512; i++)
	{
		tab[i] =0;
	}
	printf("Dimension each transfer in cache %d \n",(short)(dim_1));
	printf("Number of load in cache %d \n",(short)(n_load));
	printf("Dimension of the last transfer in cache %d \n",(short)(dim_last));
    printf("qsize %d\n",q_row);
	device = get_usb_device();
    init_usb(device);
	//matrix for the result received from the FPGA
    plhs[0] = mxCreateNumericMatrix(23, tb_size, mxUINT16_CLASS, mxREAL);
	//loop to transfer each query vector and receive the result of the classification
    for(i = 0; i < tb_size;i++)
    {
        command[0] = CLASS_CMD;
        //q size
        command[1] = q_row >> 16;
        command[2] = q_row;
        //ndim
        command[3] = n_dim;
        //kval
        command[4] = kval; 
        command[5] = (short)(n_load);
        command[6] = (short)(dim_1);
        command[7] = (short)(dim_last);
        w = send_to_usb(device,command,16);
        r = recv_ack(device,tab, 6);
        printf("Send Class Command\n");
        classifier(device,i*q_row,q_row);
        recv_from_usb(device,tab,46);
        perf_count = 0;
        perf_count = tab[5];
        perf_count = perf_count << 16;
        perf_count = perf_count | tab[4];
        perf_count = perf_count << 16;
        perf_count = perf_count | tab[3];
        perf_count = perf_count << 16;
        perf_count = perf_count | tab[2];
        time = perf_count/(144);
        data = mxGetData(plhs[0]);
		//store the answer
        for(j = 0;j<23;j++)
        {   
            data[23*i+j] = tab[j];
        }
    }
	close_usb(device);
}