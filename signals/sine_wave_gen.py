import bitstring
import numpy as np
from scipy import signal


def main():
   x = np.random.uniform(low=0.0, high=1.0, size=1024 - 16)
   x_int = (7 * x).astype(int)
   x_int = np.append([i for i in range(-8, 8)], x_int)

   with open("input_random.data", "w") as output_file:
      for value in x_int:
         output_file.write(bitstring.BitArray(f"int:4={value}").bin + "\n")

   n = np.linspace(0, 50 * np.pi, 1024, False)
   x = np.sin(2 * n)
   x_int = (7 * x).astype(int)

   with open("input_tone.data", "w") as output_file:
      for value in x_int:
         output_file.write(bitstring.BitArray(f"int:4={value}").bin + "\n")

   x = signal.square(2 * n, duty=0.3)
   x_int = (7 * x).astype(int)

   with open("input_square.data", "w") as output_file:
      for value in x_int:
         output_file.write(bitstring.BitArray(f"int:4={value}").bin + "\n")

if __name__ == "__main__":
   main()

