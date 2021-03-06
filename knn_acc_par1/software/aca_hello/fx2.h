/*
 * fx2.h
 *
 *  Created on: 13/mag/2014
 *      Author: Giovanni
 */

#ifndef FX2_H_
#define FX2_H_

/* FX2 FIFO status register bits */
#define FX2_BUSY 0x01 // FX2 busy
/* FX2 FIFO control register bits */
#define FX2_WRITE 0x01 // write
#define FX2_READ 0x02 // read
#define FX2_PKTEND 0x04 // end of packet
/* FX2 FIFO endpoints address */
#define FX2_EP2 0x00 // endpoint 2 address
#define FX2_EP4 0x01 // endpoint 4 address
#define FX2_EP6 0x02 // endpoint 6 address
#define FX2_EP8 0x03 // endpoint 8 address
#define FX2_EMPTY_N 0x0100 // flag C
#define FX2_FULL_N 0x0200 // flag B

typedef volatile struct {
int data;
int status;
int control;
int ep_address;
}fx2_struct;
extern void fx2_read(fx2_struct* fx2, int EP, int* data);
extern void fx2_read_n(fx2_struct* fx2, int EP, int* data, int n);
extern void fx2_write(fx2_struct* fx2, int EP, int data);
extern void fx2_write_n(fx2_struct* fx2, int EP, int* data, int n);


#endif /* FX2_H_ */
