# STM32

This is a glue package, to be used as parent for all STM32 families, 
to automatically de-activate the unused STM packages.

The full path name is `/ilg/STM32`.

The entire pacakge is active only if the device vendor is STMicroelectronics (id === 13). 

## Children nodes

The following nodes should be used as parents for specific family packages:

* STM32F1
* STM32F2
* STM32F3
* STM32F4
* STM32F7

Each of these nodes have a condition to activate it only if the CMSIS family is right.

### Content

Currently there are no content files in this package (only metadata files).
