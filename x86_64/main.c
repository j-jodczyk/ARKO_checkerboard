// drawing checkerboard and saving to .bmp 24 bpp file using two colors given in 24-bit form (RGB)
// main function allocates memory for the picture and passes arguments to assembler function

extern void *checkerboard24(void *img, unsigned int sqsize, unsigned int color1, unsigned int color2);

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define OUTPUT_FILE_NAME "output.bmp"

#define BMP_HEADER_SIZE 54
#define BMP_PIXEL_OFFSET 54
#define BMP_PLANES 1
#define BMP_BPP 24
#define BMP_HORIZONTAL_RES 500
#define BMP_VERTICAL_RES 500
#define BMP_DIB_HEADER_SIZE 40

#pragma pack(push, 1)

// BMPheader
typedef struct {
    unsigned char sig_0;
    unsigned char sig_1;
    uint32_t size;
    uint32_t reserved;
    uint32_t pixel_offset;
    uint32_t header_size;
    uint32_t width;
    uint32_t height;
    uint16_t planes;
    uint16_t bpp_type;
    uint32_t compression;
    uint32_t image_size;
    uint32_t horisontal_res;
    uint32_t vertical_res;
    uint32_t color_palette;
    uint32_t important_colors;
} BMPHeader;

#pragma pack(pop)

// default BMPHeader
void bmp_header(BMPHeader *header) {
    header->sig_0 = 'B';
    header->sig_1 = 'M';
    header->reserved = 0;
    header->pixel_offset = BMP_PIXEL_OFFSET;
    header->header_size = BMP_DIB_HEADER_SIZE;
    header->planes = BMP_PLANES;
    header->bpp_type = BMP_BPP;
    header->compression = 0;
    header->image_size = 0;
    header->horisontal_res = BMP_HORIZONTAL_RES;
    header->vertical_res = BMP_VERTICAL_RES;
    header->color_palette = 0;
    header->important_colors = 0;
}


unsigned char *empty_bitmap(unsigned int width, unsigned int height, size_t *output_size) {
    unsigned int row_size = (width * 3 + 3) & ~3;
    *output_size = row_size * height + BMP_HEADER_SIZE;
    unsigned char *bitmap = (unsigned char *)malloc(*output_size);

    BMPHeader header;
    bmp_header(&header);
    header.size = *output_size;
    header.width = width;
    header.height = height;

    memcpy(bitmap, &header, BMP_HEADER_SIZE); // copy header to dynamicly allocated memory
    for (int i = BMP_HEADER_SIZE; i < *output_size; ++i) {
        bitmap[i] = 0xFF; // generating map with only white pixels
    }
    return bitmap;

}

// checkerboard24 in C and only black and white
void chess(unsigned char *img, unsigned int height, unsigned int width, unsigned int sqsize)
{
    const int nPitch = (width * 3 + 3) & ~3;
    int yOffset = 0;
	int xOffset = 0;
	int Index = 54;

	for(int y = 0;y < height;y++)
	{
		xOffset = 0;

		for(int x = 0;x < width;x++)
		{
			Index = yOffset + xOffset + 54;

			int nX = x / sqsize, nY = y / sqsize;

			if ( ((nX + nY) % 2 == 0) )
			{
				img[Index] = 255;
				img[Index+1] = 255;
				img[Index+2] = 255;
			}
			else
			{
				img[Index] = 0;
				img[Index+1] = 0;
				img[Index+2] = 0;
			}
			xOffset += 3;
		}

		yOffset += nPitch;
	}
}


// argv : width, height, sqsize, color1, color2, file_name
int main(int argc, char *argv[])
{
    if (argc!=7)
	{
		printf ("Incorrect number of arguments.\n");
		return 0;
	}

    size_t bmp_size = 0;
    unsigned int w = atoi(argv[1]);
    unsigned int h = atoi(argv[2]);

    unsigned char *bmp_buffer = empty_bitmap(w, h, &bmp_size);

    FILE *file;
    file = fopen(argv[6], "wb");

    unsigned int sqsize = atoi(argv[3]);
    unsigned int color1 = strtol(argv[4], NULL, 16);
    unsigned int color2 = strtol(argv[5], NULL, 16);

    checkerboard24(bmp_buffer, sqsize, color1, color2);
    //chess(bmp_buffer, 10, 12, 3);

    fwrite(bmp_buffer, 1, bmp_size, file);
    fclose(file);

    free(bmp_buffer);
    return 0;
}
