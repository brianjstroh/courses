## In order to eliminate the need for recalculating the inverse matrix,
## cacheSolve will check with makeCacheMatrix to verify whether or not
## the matrix has already been inverted. If it has been inverted, then 
## cacheSolve will return the call to getInvertedMatrix. Otherwise, 
## the function 'solve' will be run on the matrix and the result will
## be stored via setInvertedMatrix. The inverted matrix will be returned
## on the first call to cacheSolve as well, just without the 'getting
## cached data' message.

## This function is essentially a object constructor for caching an
## a matrix and its inverted counterpart.

makeCacheMatrix <- function(x = matrix()) {
      m <- NULL
      set <- function(y) {
            x <<- y
            m <<- NULL
      }
      get <- function() x
      setInvertedMatrix <- function(invertedMatrix) m <<- invertedMatrix
      getInvertedMatrix <- function() m
      list(set = set, get = get,
           setInvertedMatrix = setInvertedMatrix,
           getInvertedMatrix = getInvertedMatrix)
}


## This function will invert a matrix and store the result in the
## object created with the call to makeCacheMatrix. If the matrix has
## already been inverted, this function will instead retrieve the
## inverted matrix from the list populated from the previous call to
## cacheSolve.

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
      m <- x$getInvertedMatrix()
      if(!is.null(m)) {
            message("getting cached data")
            return(m)
      }
      data <- x$get()
      m <- solve(data)
      x$setInvertedMatrix(m)
      m
}
