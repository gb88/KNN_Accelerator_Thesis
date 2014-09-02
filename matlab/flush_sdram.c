#include "mex.h"
#include "matrix.h"
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

void transfer_data(usb_dev_handle*device, unsigned int base_addr)
{
	FILE * pFile;
	float size;
	int w,r;
	pFile = fopen ("flush.dat","r");
	if (pFile==NULL)
	{
		printf("Error on open file data.dat\n");
		exit(1);	
	}
	else
	{
		int i = 0;
		int hexval;
		unsigned short shortval;
		unsigned short tab[512];//da segare
		unsigned short command[512];
		float packet_number = 0;
        int k = 0;
		int fdim = 0;
        int r = 0;
		fseek(pFile, 0, SEEK_END); // seek to end of file
		size = ftell(pFile); // get current file pointer
		fseek(pFile, 0, SEEK_SET); // seek back to beginning of file
        printf("size %f\n",size);
		size = (size+1)/9;
		  printf("size %f\n",size);
		if (2*size < 254)
			packet_number = 1;
		else
			packet_number = ceil(2*size/254);
		//send flush command	
		command[0] = FLUSH_COMM;
		//total dimension
		shortval = (int)(size)>>16;
		command[1] = shortval;
		shortval = (int)(size);
		command[2] = shortval;
		//number of packet
		shortval = (int)(packet_number)>>16;
		command[3] = shortval;
		shortval = (int)(packet_number);
		command[4] = shortval; 
		command[5] = base_addr; 
		w = send_to_usb(device,command,16);
		r = recv_ack(device,tab, 6);
        printf("Send Command\n");
		printf("Send %d Packet With Data\n", (int)packet_number);
		//number of packet to be updated
		shortval = (int)(packet_number)>>16;
		command[0] = shortval;
		shortval = (int)(packet_number);
		command[1] = shortval;
		
		for (k = 0; k < (int)packet_number; k++)
		{
			for (i = 0; fdim < size && i < 127; i++)
			{
				fscanf(pFile,"%x",&hexval);
				//printf("hex %x \n",hexval);
				shortval = hexval>>16;
				//printf("short %x \n",shortval);
				//most significant part
				command[2+2*i] = shortval;
				//least significant part
				shortval = hexval;
				//printf("short %x %d \n",shortval,3+2*i);
				command[3+2*i] = shortval;
				fdim++;
			}
			send_to_usb(device,command, 512);
			
			r = usb_bulk_read(device, 0x88, (char*)tab, 512, 1000);
			if(r < 0 )
			{
				printf("Error on read : %s\n", usb_strerror());
			}
			printf("Send Packet %d\n", k);
		}		
	}
	fclose(pFile);
}

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

void close_usb(usb_dev_handle *device)
{
	usb_reset(device);
	usb_release_interface(device, 0);
    usb_close(device);
	return;
}

void mexFunction(int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[]) 
{
	unsigned short command[256];
	float n_loc = 0.0;
	float base_addr = 0.0;
	float n_dim = 0.0;
    unsigned int memword = 0;
    usb_dev_handle	*device;
    n_dim = (float)mxGetScalar(prhs[0]);
    memword = (float)mxGetScalar(prhs[1]);
	n_loc = (ceil(n_dim/3)+1);
	base_addr = (memword -(n_loc-1))*4;
	device = get_usb_device();
    init_usb(device);
    printf("Fill the SDRAM... %f\n",n_dim);	
	transfer_data(device,(int)base_addr);
	recv_ack(device,command, 6);
	close_usb(device);
    printf("Done...\n");	
}