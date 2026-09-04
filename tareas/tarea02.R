"Hello World!"
5 + 5

plot(1:10)

#Data Type
my_var <- 30 # my_var como tipo numerico
my_var
my_var1 <- "Juan" # my_var1 is  of type letras (aka string)
my_var1

# numerico
x <- 10.5
class(x)

# entero
x <- 1000L
class(x)

# complejo
x <- 9i + 3
class(x)

# character/string
x <- "R is exciting"
class(x)

# logical/boolean
x <- TRUE
class(x)

# R Numbers

x <- 10.5
y <- 55

# Print values of x and y
x
y

# Print the class name of x and y
class(x)
class(y)

x <- 1000L
y <- 55L

# Print values of x and y
x
y

# Print the class name of x and y
class(x)
class(y)


x <- 3+5i
y <- 5i

# Print values of x and y
x
y

# Print the class name of x and y
class(x)
class(y)

#Conversion de numeros
x <- 1L # integer
y <- 2 # numeric

# convert from integer to numeric:
a <- as.numeric(x)

# convert from numeric to integer:
b <- as.integer(y)

# print values of x and y
x
y

# print the class name of a and b
class(a)
class(b)

###STRINGS###

"hello"
'hello'

str <- "Hello"
str #imprime el valor de str en la consola

str.1 <- "Lorem ipsum dolor sit amet,
consectetur adipiscing elit,
sed do eiusmod tempor incididunt
ut labore et dolore magna aliqua."
str.1

cat(str.1)

str.2 <- "Hello World!"

nchar(str.2)
grepl("H", str.2)
grepl("Hello", str.2)
grepl("X", str.2)


str1 <- "Hello"
str2 <- "World"

paste(str1, str2)

##Booleans y valores logicos##
10 > 9    # TRUE because 10 is greater than 9
10 == 9   # FALSE because 10 is not equal to 9
10 < 9    # FALSE because 10 is greater than 9


a <- 10
b <- 9

a > b

a <- 200
b <- 33

a <- 200
b <- 33

if (b > a) {
  print ("b is greater than a")
} else {
  print("b is not greater than a")
}

##Operadores##
10 + 5
my_var <- 3

my_var <<- 3

3 -> my_var

3 ->> my_var
my_var # print my_var


##If else##
a <- 33
b <- 200

if (b > a) {
  print("b is greater than a") } 

a <- 33
b <- 33

if (b > a) {
  print("b is greater than a")
} else if (a == b) {
  print ("a and b are equal")}

a <- 200
b <- 33

if (b > a) {
  print("b is greater than a")
} else if (a == b) {
  print("a and b are equal")
} else {
  print("a is greater than b")
}

a <- 200
b <- 33

if (b > a) {
  print("b is greater than a")
} else {
  print("b is not greater than a")
}

## While loop ##

i <- 1
while (i < 6) {
  print(i)
  i <- i + 1
  }

#Parar cuando se llega a 4#

j<- 1
while (j < 6) {
  print(j)
  j <- j + 1
  if (j == 4) {   break   }
}

#salterar un valor#
x <- 0
while (x< 6) {
  x <- x + 1
  if (x == 3) {
    next
  }
  print(x)
  
  #asignarle un valor palabras y contar#
  dice <- 1
  while (dice <= 6) {
    if (dice < 6) {
      print("No Yahtzee")
    } else {
      print("Yahtzee!")
    }
    dice <- dice + 1
  }
  
  #For Loops#
  for (x in 1:10) {
    print(x)
  }
  fruits <- list("apple", "banana", "cherry")
  
  for (x in fruits) {
    print(x)
  }
  
  dice <- c(1, 2, 3, 4, 5, 6)
  
  for (x in dice) {
    print(x)
  }
  ##Cuando llega a cherry cortar##
  fruits <- list("apple", "banana", "cherry")
  
  for (x in fruits) {
    if (x == "cherry") {
      break
    }
    print(x)
  }

  #saltear banana#
  fruits <- list("apple", "banana", "cherry")
  
  for (x in fruits) {
    if (x == "banana") {
      next
    }
    print(x)
  }
  
  #Imprimir una palabra cuando el valor llega a X numero##
  dice <- 1:6
  
  for(x in dice) {
    if (x == 6) {
      print(paste("The dice number is", x, "Yahtzee!"))
    } else {
      print(paste("The dice number is", x, "Not Yahtzee"))
    }
  }
  
  ##Vectores##
  fruits <- c("banana", "apple", "orange")
  fruits
  
  numbers <- c(1, 2, 3)
  numbers
  
  numbers <- 1:10
  
  numbers
  
  numbers1 <- 1.5:6.5
  numbers1
  
  numbers2 <- 1.5:6.3 ##No usas el ultimo pq no encaja en secuencia##
  numbers2
  
  log_values <- c(TRUE, FALSE, TRUE, FALSE)
  log_values
  
  fruits <- c("banana", "apple", "orange")
  length(fruits)
  
  ##Ordenar el vector##
  fruits <- c("banana", "apple", "orange", "mango", "lemon")
  numbers <- c(13, 3, 5, 7, 20, 2)
  sort(fruits)  # Sort a string
  sort(numbers) # Sort numbers
  
  #dame el elemento n1##
  fruits <- c("banana", "apple", "orange")
  # Access the first item (banana)
  fruits[1]
  
  fruits <- c("banana", "apple", "orange", "mango", "lemon")
  # Access the first and third item (banana and orange)
  fruits[c(1, 3,5) ]
  
  fruits <- c("banana", "apple", "orange", "mango", "lemon")
  # Access all items except for the first item
  fruits[c(-1)]
  
  #Cambiar un elemento##
  fruits <- c("banana", "apple", "orange", "mango", "lemon")
    # Change "banana" to "pear"
  fruits[1] <- "pear"
    # Print fruits
  fruits
  #Repetir 3 veces los valores#
  repeat_each <- rep(c(1,2,3), each = 3)
  repeat_each
  #Repetir la secuencia 3 veces##
  repeat_times <- rep(c(1,2,3), times = 3)
  repeat_times
#Repetir los valores de tiempos diferentes#
  repeat_indepent <- rep(c(1,2,3), times = c(5,2,1))
  repeat_indepent  
  
  #Vector#
  numbers <- 1:10
  numbers
  numbers <- seq(from = 0, to = 100, by = 20)
  numbers
  
  ##R LISTS##
  # List of strings
  thislist <- list("apple", "banana", "cherry")
  
  # Imprimir la lista
  thislist
  
  thislist <- list("apple", "banana", "cherry")
  thislist[1] #elemento 1 de la lista
  
  thislist <- list("apple", "banana", "cherry")
  thislist[1] <- "blackcurrant"
  
  # Print the updated list
  thislist
  
  #Medir la cantidad de elementos#
  thislist <- list("apple", "banana", "cherry")
  
  length(thislist)
  
  #esta el elemento en la lista#
  thislist <- list("apple", "banana", "cherry")
  "apple" %in% thislist
  
  thislist <- list("apple", "banana", "cherry")
  append(thislist, "orange")
  
  #le pones en que lugar se inserta un elemento nuevo#
  thislist <- list("apple", "banana", "cherry")
  append(thislist, "orange", after = 2)
  
  #eliminar un elemento#
  thislist <- list("apple", "banana", "cherry")
  newlist <- thislist[-1]
  # Print the new list
  newlist
  
  ##Listar algunos elementos indexando##
  thislist <- list("apple", "banana", "cherry", "orange", "kiwi", "melon", "mango")
  (thislist)[2:5]
  
  thislist <- list("apple", "banana", "cherry")
  
  for (x in thislist) {
    print(x)
  }
  
  list1 <- list("a", "b", "c")
  list2 <- list(1,2,3)
  list3 <- c(list1,list2)
  
  list3
  
  # Create a matrix
  thismatrix <- matrix(c(1,2,3,4,5,6), nrow = 3, ncol = 2)
  # Print the matrix
  thismatrix
  
  thismatrix <- matrix(c("apple", "banana", "cherry", "orange"), nrow = 2, ncol = 2)
  thismatrix
  ##Acceder a un elemento##
  thismatrix <- matrix(c("apple", "banana", "cherry", "orange"), nrow = 2, ncol = 2)
  thismatrix[1, 2]
  thismatrix[2,] #Imprimir la segunda fila
  thismatrix[,2] #Columna
  
  thismatrix <- matrix(c("apple", "banana", "cherry", "orange","grape", "pineapple", "pear", "melon", "fig"), nrow = 3, ncol = 3)
  thismatrix[c(1,2),]
  
  thismatrix <- matrix(c("apple", "banana", "cherry", "orange","grape", "pineapple", "pear", "melon", "fig"), nrow = 3, ncol = 3)
  thismatrix[, c(1,2)]
  
  
  #agregar columnas a la matriz#
  thismatrix <- matrix(c("apple", "banana", "cherry", "orange","grape", "pineapple", "pear", "melon", "fig"), nrow = 3, ncol = 3)
  newmatrix <- cbind(thismatrix, c("strawberry", "blueberry", "raspberry"))
  # Print the new matrix
  newmatrix
  
  #agregar fila a la matriz#
  thismatrix <- matrix(c("apple", "banana", "cherry", "orange","grape", "pineapple", "pear", "melon", "fig"), nrow = 3, ncol = 3)
  
  newmatrix <- rbind(thismatrix, c("strawberry", "blueberry", "raspberry"))
  
  # Print the new matrix
  newmatrix
  
  #Remover filas y columnas#
  thismatrix <- matrix(c("apple", "banana", "cherry", "orange", "mango", "pineapple"), nrow = 3, ncol =2)
  
  #Remove the first row and the first column
  thismatrix <- thismatrix[-c(1), -c(1)]
  
  thismatrix
  
  thismatrix <- matrix(c("apple", "banana", "cherry", "orange"), nrow = 2, ncol = 2)
  
  "apple" %in% thismatrix
  
  #dimensiones#
  thismatrix <- matrix(c("apple", "banana", "cherry", "orange"), nrow = 2, ncol = 2)
  dim(thismatrix)
  #elementos#
  thismatrix <- matrix(c("apple", "banana", "cherry", "orange"), nrow = 2, ncol = 2)
  length(thismatrix)
  
  thismatrix <- matrix(c("apple", "banana", "cherry", "orange"), nrow = 2, ncol = 2)
  
  for (rows in 1:nrow(thismatrix)) {
    for (columns in 1:ncol(thismatrix)) {
      print(thismatrix[rows, columns])
    }
  }
  
  # Combine matrices
  Matrix1 <- matrix(c("apple", "banana", "cherry", "grape"), nrow = 2, ncol = 2)
  Matrix2 <- matrix(c("orange", "mango", "pineapple", "watermelon"), nrow = 2, ncol = 2)
  
  # Adding it as a rows
  Matrix_Combined <- rbind(Matrix1, Matrix2)
  Matrix_Combined
  
  # Adding it as a columns
  Matrix_Combined <- cbind(Matrix1, Matrix2)
  Matrix_Combined
  
  thisarray <- c(1:24)
  thisarray
  
  # An array with more than one dimension
  multiarray <- array(thisarray, dim = c(4, 3, 2))
  multiarray
  
  
  thisarray <- c(1:24)
  multiarray <- array(thisarray, dim = c(4, 3, 2))
  multiarray
  multiarray[2, 3, 2] #de la segunda matriz la columna 3 fila 2#
  
  
  thisarray <- c(1:24)
  
  # Access all the items from the first row from matrix one
  multiarray <- array(thisarray, dim = c(4, 3, 2))
  multiarray[c(1),,1]
  
  # Access all the items from the first column from matrix one
  multiarray <- array(thisarray, dim = c(4, 3, 2))
  multiarray[,c(1),1]
  
  thisarray <- c(1:24)
  multiarray <- array(thisarray, dim = c(4, 3, 2))
  
  2 %in% multiarray
  
  thisarray <- c(1:24)
  multiarray <- array(thisarray, dim = c(4, 3, 2))
  multiarray
  dim(multiarray) #3columnas, 4filas 
  
  thisarray <- c(1:24)
  multiarray <- array(thisarray, dim = c(4, 3, 2))
  
  length(multiarray) #elementos#
  
  
  thisarray <- c(1:24)
  multiarray <- array(thisarray, dim = c(4, 3, 2))
  
  for(x in multiarray){
    print(x)
  }
  
  # Create a data frame
  Data_Frame <- data.frame (
    Training = c("Strength", "Stamina", "Other"),
    Pulse = c(100, 150, 120),
    Duration = c(60, 30, 45)
  )
  
  # Print the data frame
  Data_Frame
  summary(Data_Frame)
  Data_Frame[1]
  Data_Frame[["Training"]]
  Data_Frame$Training
  
  New_row_DF <- rbind(Data_Frame, c("Strength", 110, 110))
  
  # Print the new row
  New_row_DF
  
  New_col_DF <- cbind(Data_Frame, Steps = c(1000, 6000, 2000))
  
  # Print the new column
  New_col_DF
  
  Data_Frame_New <- Data_Frame[-c(1), -c(1)]
  
  # Print the new data frame
  Data_Frame_New
  dim(Data_Frame)
  ncol(Data_Frame)
  nrow(Data_Frame)
  length(Data_Frame) #columnas#
  
  #combinacion vertical#
  Data_Frame1 <- data.frame (
    Training = c("Strength", "Stamina", "Other"),
    Pulse = c(100, 150, 120),
    Duration = c(60, 30, 45)
  )
  
  Data_Frame2 <- data.frame (
    Training = c("Stamina", "Stamina", "Strength"),
    Pulse = c(140, 150, 160),
    Duration = c(30, 30, 20)
  )
  
  New_Data_Frame <- rbind(Data_Frame1, Data_Frame2)
  New_Data_Frame
  
  #combinacion con más columnas#
  Data_Frame3 <- data.frame (
    Training = c("Strength", "Stamina", "Other"),
    Pulse = c(100, 150, 120),
    Duration = c(60, 30, 45)
  )
  
  Data_Frame4 <- data.frame (
    Steps = c(3000, 6000, 2000),
    Calories = c(300, 400, 300)
  )
  
  New_Data_Frame1 <- cbind(Data_Frame3, Data_Frame4)
  New_Data_Frame1
  
  ##Factores#
  # Create a factor
  music_genre <- factor(c("Jazz", "Rock", "Classic", "Classic", "Pop", "Jazz", "Rock", "Jazz"))
  
  # Print the factor
  music_genre
  
  music_genre <- factor(c("Jazz", "Rock", "Classic", "Classic", "Pop", "Jazz", "Rock", "Jazz"), levels = c("Classic", "Jazz", "Pop", "Rock", "Other"))
  levels(music_genre)
  
  length(music_genre)
  music_genre[3]
  music_genre[3] <- "Pop"
  
  music_genre[3]
  
  music_genre <- factor(c("Jazz", "Rock", "Classic", "Classic", "Pop", "Jazz", "Rock", "Jazz"), levels = c("Classic", "Jazz", "Pop", "Rock", "Opera"))
  
  music_genre[3] <- "Opera"
  
  music_genre[3]