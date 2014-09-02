/*
 * fx2.c
 *
 *  Created on: 13/mag/2014
 *      Author: Giovanni
 */

#include "fx2.h"
/*
* read a single word of 16 bits in FIFO EP and save it in data
*/
void fx2_read(fx2_struct* fx2, int EP, int* data){
 while(fx2->status & FX2_BUSY); /* wait until fx2 is ready*/
 fx2->ep_address = EP;   /* set EP address */
 fx2->control = FX2_READ;   /* read */
 while(fx2->status & FX2_BUSY); /* wait until fx2 is ready*/
 *data = fx2->data;    /* read data */
}
/*
* read an array of size n x 16 bits in FIFO EP and save it in data
*/
void fx2_read_n(fx2_struct* fx2, int EP, int* data, int n){
while(fx2->status & FX2_BUSY); /* wait until fx2 is ready*/
fx2->ep_address = EP;   /* set EP address */
int i = 0;
for(i=0;i<n;i++){
fx2->control = FX2_READ;  /* read */
while(fx2->status & FX2_BUSY); /* wait until fx2 is ready*/
data[i] = fx2->data;   /* read data */
}
}
/*
* write data, a single word of 16 bits, in FIFO EP
*/
void fx2_write(fx2_struct* fx2, int EP, int data){
while(fx2->status & FX2_BUSY);  /* wait until fx2 is ready*/
fx2->ep_address = EP;   /* set EP address */
fx2->data = data;    /* set data */
fx2->control = FX2_PKTEND | FX2_WRITE; /* write and commit */
}
/*
* write the array data of size n x 16 bits in FIFO EP
*/
void fx2_write_n(fx2_struct* fx2, int EP, int* data, int n){
while(fx2->status & FX2_BUSY);  /* wait until fx2 is ready*/
fx2->ep_address = EP;   /* set EP address */
int i=0;
for(i=0;i<n-1;i++){
while(fx2->status & FX2_BUSY); /* wait until fx2 is ready*/
fx2->data = data[i];   /* set data */
fx2->control = FX2_WRITE;  /* write */
}

while(fx2->status & FX2_BUSY);  /* wait until fx2 is ready*/
fx2->data = data[n-1];   /* set data */
fx2->control = FX2_PKTEND | FX2_WRITE; /* write and commit last data */
}
