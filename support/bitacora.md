##### 22 de junio

###### arbitro.v

* tablas de verdad fueron capturadas en formato little endian. El atributo INIT de la primitiva LUT6 de Xilinx los requiere en formato big endian. Procedimiento para conversion:
  * Copiar vector de salida de arbiter_truth_table.odt
  * Pegar en Geany y eliminar todo caracter '\n' del archivo. Esto se puede llevar a cabo mediante una sustitucion. La cadena resultante queda en formato little endian.
  * Abrir una consola en python y almacenar el vector en una variable string.
  * Imprimir la cadena en orden inverso mediante string[::-1]
