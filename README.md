# STM32

This is a glue package, acting as parent for all STM32 families, 
to de-activate all unused packages.

The full path name is `/ilg/STM32`.

## Children nodes

The following nodes should be used as parents for specific family packages:

* STM32F1
* STM32F2
* STM32F3
* STM32F4
* STM32F7

Each of these nodes have a condition to activate it only if the CMSIS family is right.
