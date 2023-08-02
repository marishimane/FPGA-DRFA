# Desert Rain Frog Architecture - Programación de softcores en FPGA

Este repositorio plantea una solución a un trabajo práctico correspondiente a la materia **Programación de Softcores en FPGA** de la carrera **Ciencias de la Computación de la Universidad de Buenos Aires**.

## Integrantes
> - Mariana Shimane
> - Francisco Roth
> - Luis José Martín

## Descripción detallada de la arquitectura

En el siguiente archivo se encuentra la descripción detallada de la arquitectura implementada, así como también las decisiones de diseño tomadas, gráficos del datapath y del set de instrucciones.

### [Especificación Desert Rain Frog Architecture](https://docs.google.com/document/d/19R2ALrrsPaSP3NljamkW2M2_IgvnEavfRGsxlvx-o_w/edit)

## Estructura
En la carpeta root del proyecto se encuentran todos los archivos de Verilog de los componentes del sistema, así como también los arhivos de testbench para cada uno.

Además, el archivo `drf_system.v` contiene la descripción de la arquitectura completa, y el archivo `drf_system_test.v` contiene el testbench de la misma para que sea corrido sobre la memoria de código correspondiente al ejemplo del juego Simon.

Algunos archivos assembly de ejemplo se encuentran en la carpeta `ejemplos_asm`. Los más importantes son los correspondientes al juego Simon.

## Generación de la memoria de código de la unidad de control
La memoria de código se genera a partir de lo especificado en el archivo `utils/signals_to_state_machine.py`.

### Ejemplo:
```bash
python3 utils/signals_to_state_machine.py > state_machine.mem
```

Acá el output del script es redirigido al archivo state_machine.mem que es usuado por la unidad de control.

## Ensamblado
La memoria de código general se genera en base al archivo **XYZ.asm** especificado. 

### Ejemplo:
```bash
python3 assembler/assembler.py XYZ.asm
```
Esto genera un archivo `XYZCodeVerilog.mem` en la raíz del proyecto, cuyo contenido debe ser puesto en el archivo `code_memory_example.mem` para que el módulo **code_memory** lo tome al sintetizar.

## Distribución
Autorizamos la distribución de esta solución como material de referencia para futuros trabajos prácticos.
