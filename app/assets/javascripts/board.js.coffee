#
# * Copyright (C) 2014 Google Inc. All Rights Reserved.
# *
# * Licensed under the Apache License, Version 2.0 (the "License");
# * you may not use this file except in compliance with the License.
# * You may obtain a copy of the License at
# *
# *      http://www.apache.org/licenses/LICENSE-2.0
# *
# * Unless required by applicable law or agreed to in writing, software
# * distributed under the License is distributed on an "AS IS" BASIS,
# * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# * See the License for the specific language governing permissions and
# * limitations under the License.
#


$ ->
    console.log "Loaded board js!"

###*
@fileoverview
This file represents a TicTacToe board object, with all needed drawing and
state update functions.
###

###*
Creates an empty board object with no location
@param {CanvasRenderingContext2D} context the 2D context of the canvas that
the board is drawn on.
@constructor
###
board = (context) ->
  @mContext = context
  @mGameResult = -1
  @mWinningLocation = -1
  @mBoard = new Array(3)
  i = 0

  while i < @mBoard.length
    @mBoard[i] = new Array(3)
    j = 0

    while j < @mBoard[0].length
      @mBoard[i][j] = STATE.EMPTY
      j++
    i++
  return

###*
Resets the board to a starting state.
@this {board}
###
boardReset = ->
  @mGameResult = -1
  @mWinningLocation = -1
  @mContext.beginPath()
  @mContext.clearRect @X, @Y, @mContext.canvas.width, @mContext.canvas.height
  @drawGrid()
  i = 0

  while i < @mBoard.length
    j = 0

    while j < @mBoard[0].length
      @mBoard[i][j] = STATE.EMPTY
      j++
    i++
  return

###*
Calculates and sets internally the board's width, height, x, and y.
@this {board}
###
boardCalcDimensions = ->
  if @mContext.canvas.width > @mContext.canvas.height
    @dimension = @mContext.canvas.height - 2 * @margin
  else
    @dimension = @mContext.canvas.width - 2 * @margin
  @X = (@mContext.canvas.width - @dimension) / 2
  @Y = (@mContext.canvas.height - @dimension) / 2
  @cellWidth = @dimension / 3
  return

###*
Calculates board dimensions.
@this {board}
###
boardClear = ->
  @calcDimensions()
  return

###*
Draws the hashmark-shaped grid for TicTacToe.
@this {board}
###
boardDrawGrid = ->

  # draw background
  @mContext.fillStyle = "#BDBDBD"
  @mContext.strokeStyle = "#000000"
  @mContext.fillRect @X, @Y, @dimension, @dimension

  # draw grid
  @mContext.lineWidth = 5
  @mContext.moveTo @X + @cellWidth, @Y
  @mContext.lineTo @X + @cellWidth, @Y + @dimension
  @mContext.stroke()
  @mContext.moveTo @X + @cellWidth * 2, @Y
  @mContext.lineTo @X + @cellWidth * 2, @Y + @dimension
  @mContext.stroke()
  @mContext.moveTo @X, @Y + @cellWidth
  @mContext.lineTo @X + @dimension, @Y + @cellWidth
  @mContext.stroke()
  @mContext.moveTo @X, @Y + @cellWidth * 2
  @mContext.lineTo @X + @dimension, @Y + @cellWidth * 2
  @mContext.stroke()
  return

###*
Draws an O symbol in the given row and column.
@param {number} row the row the piece should be placed in.
@param {number} col the column the piece should be placed in.
@this {board}
@return {boolean} true if the selected row and column is a valid square
to put a piece in.
###
boardDrawNaught = (row, col) ->
  unless @mBoard[row][col] is STATE.EMPTY
    console.info "Invalid position: " + row + " " + col + " val:" + @mBoard[row][col]
    return false
  @mBoard[row][col] = STATE.NAUGHT
  @mContext.lineWidth = 8
  @mContext.strokeStyle = "#FFFF00"
  @mContext.beginPath()
  @mContext.arc @X + @cellWidth * (col + 0.5), @Y + @cellWidth * (row + 0.5), @cellWidth / 2 - @pieceMargin, 0, 360
  @mContext.stroke()
  true

###*
Draws an X symbol in the given row and column.
@param {number} row the row the piece should be placed in.
@param {number} col the column the piece should be placed in.
@this {board}
@return {boolean} true if the selected row and column is a valid square
to put a piece in.
###
boardDrawCross = (row, col) ->
  unless @mBoard[row][col] is STATE.EMPTY
    console.info "Invalid position: " + row + " " + col + " val:" + @mBoard[row][col]
    return false
  @mBoard[row][col] = STATE.CROSS
  @mContext.strokeStyle = "#0000FF"
  @mContext.lineWidth = 8
  @mContext.beginPath()
  @mContext.moveTo @X + @cellWidth * col + @pieceMargin, @Y + @cellWidth * row + @pieceMargin
  @mContext.lineTo @X + @cellWidth * (col + 1) - @pieceMargin, @Y + @cellWidth * (row + 1) - @pieceMargin
  @mContext.stroke()
  @mContext.moveTo @X + @cellWidth * (col + 1) - @pieceMargin, @Y + @cellWidth * row + @pieceMargin
  @mContext.lineTo @X + @cellWidth * col + @pieceMargin, @Y + @cellWidth * (row + 1) - @pieceMargin
  @mContext.stroke()
  true

###*
Draws the line connecting the winning three pieces.
@this {board}
@return {boolean} true if the winning three spaces is valid.
###
boardDrawWinningLocation = ->
  xStart = yStart = xEnd = yEnd = -1
  if @mWinningLocation is WINNING_LOCATION.ROW_0
    xStart = 0.05
    xEnd = 2.95
    yStart = yEnd = 0.5
  else if @mWinningLocation is WINNING_LOCATION.ROW_1
    xStart = 0.05
    xEnd = 2.95
    yStart = yEnd = 1.5
  else if @mWinningLocation is WINNING_LOCATION.ROW_2
    xStart = 0.05
    xEnd = 2.95
    yStart = yEnd = 2.5
  else if @mWinningLocation is WINNING_LOCATION.COLUMN_0
    yStart = 0.05
    yEnd = 2.95
    xStart = xEnd = 0.5
  else if @mWinningLocation is WINNING_LOCATION.COLUMN_1
    yStart = 0.05
    yEnd = 2.95
    xStart = xEnd = 1.5
  else if @mWinningLocation is WINNING_LOCATION.COLUMN_2
    yStart = 0.05
    yEnd = 2.95
    xStart = xEnd = 2.5
  else if @mWinningLocation is WINNING_LOCATION.DIAGONAL_TOPLEFT
    xStart = yStart = 0.05
    xEnd = yEnd = 2.95
  else if @mWinningLocation is WINNING_LOCATION.DIAGONAL_BOTTOMLEFT
    xStart = yEnd = 2.95
    yStart = xEnd = 0.05
  else
    console.log "Unknown winning location: " + @mWinningLocation
    return false
  @mContext.lineWidth = 10
  @mContext.strokeStyle = "#FF0000"
  @mContext.beginPath()
  @mContext.moveTo @X + @cellWidth * xStart, @Y + @cellWidth * yStart
  @mContext.lineTo @X + @cellWidth * xEnd, @Y + @cellWidth * yEnd
  @mContext.stroke()
  true

###*
Logs the current state of the board's pieces and results.
@this {board}
###
boardPrintBoard = ->
  i = 0

  while i < @mBoard.length
    console.log "[ " + @mBoard[i][0] + ", " + @mBoard[i][1] + ", " + @mBoard[i][2] + " ]"
    i++
  console.log "gameResult: " + @mGameResult
  console.log "winningLoc: " + @mWinningLocation
  return

###*
Determines whether the game is over, whether by winning or draw.
@this {board}
@return {boolean} true if the game ended via a win or a draw.
###
boardIsGameOver = ->
  isBoardFull = true
  @printBoard()

  # Check the rows
  i = 0

  while i < @mBoard.length
    if (@mBoard[i][0] isnt STATE.EMPTY) and (@mBoard[i][1] is @mBoard[i][0]) and (@mBoard[i][2] is @mBoard[i][0])
      @mGameResult = GAME_RESULT.O_WON
      @mGameResult = GAME_RESULT.X_WON  if @mBoard[i][0] is STATE.CROSS
      if i is 0
        @mWinningLocation = WINNING_LOCATION.ROW_0
      else if i is 1
        @mWinningLocation = WINNING_LOCATION.ROW_1
      else
        @mWinningLocation = WINNING_LOCATION.ROW_2
    isBoardFull = false  if (isBoardFull is true) and ((@mBoard[i][0] is STATE.EMPTY) or (@mBoard[i][1] is STATE.EMPTY) or (@mBoard[i][2] is STATE.EMPTY))
    i++
  @printBoard()

  # Check the columns
  j = 0

  while j < @mBoard[0].length
    if (@mBoard[0][j] isnt STATE.EMPTY) and (@mBoard[1][j] is @mBoard[0][j]) and (@mBoard[2][j] is @mBoard[0][j])
      @mGameResult = GAME_RESULT.O_WON
      @mGameResult = GAME_RESULT.X_WON  if @mBoard[0][j] is STATE.CROSS
      if j is 0
        @mWinningLocation = WINNING_LOCATION.COLUMN_0
      else if j is 1
        @mWinningLocation = WINNING_LOCATION.COLUMN_1
      else
        @mWinningLocation = WINNING_LOCATION.COLUMN_2
      break
    j++
  @printBoard()

  # Check diagonals
  if (@mBoard[0][0] isnt STATE.EMPTY) and (@mBoard[1][1] is @mBoard[0][0]) and (@mBoard[2][2] is @mBoard[0][0])
    @mWinningLocation = WINNING_LOCATION.DIAGONAL_TOPLEFT
    @mGameResult = GAME_RESULT.O_WON
    @mGameResult = GAME_RESULT.X_WON  if @mBoard[0][0] is STATE.CROSS
  else if (@mBoard[0][2] isnt STATE.EMPTY) and (@mBoard[1][1] is @mBoard[0][2]) and (@mBoard[2][0] is @mBoard[0][2])
    @mWinningLocation = WINNING_LOCATION.DIAGONAL_BOTTOMLEFT
    @mGameResult = GAME_RESULT.O_WON
    @mGameResult = GAME_RESULT.X_WON  if @mBoard[0][2] is STATE.CROSS

  # Check whether the game was won or drawn
  if (@mGameResult is GAME_RESULT.X_WON) or (@mGameResult is GAME_RESULT.O_WON)
    @drawWinningLocation()
    return true
  if isBoardFull is true
    @mGameResult = GAME_RESULT.DRAW
    return true
  false

###*
Updates this game's result to abandoned.
@this {board}
###
boardSetGameAbandoned = ->
  @mGameResult = GAME_RESULT.ABANDONED
  return
boardGetGameResult = ->
  @mGameResult
boardGetWinningLocation = ->
  @mWinningLocation
STATE =
  EMPTY: 0
  CROSS: 1
  NAUGHT: 2

GAME_RESULT =
  X_WON: "X-won"
  O_WON: "O-won"
  DRAW: "draw"
  ABANDONED: "abandoned"

WINNING_LOCATION =
  ROW_0: 0
  ROW_1: 1
  ROW_2: 2
  COLUMN_0: 3
  COLUMN_1: 4
  COLUMN_2: 5
  DIAGONAL_TOPLEFT: 6
  DIAGONAL_BOTTOMLEFT: 7

board::calcDimensions = boardCalcDimensions
board::clear = boardClear
board::drawCross = boardDrawCross
board::drawGrid = boardDrawGrid
board::drawNaught = boardDrawNaught
board::drawWinningLocation = boardDrawWinningLocation
board::getGameResult = boardGetGameResult
board::getWinningLocation = boardGetWinningLocation
board::isGameOver = boardIsGameOver
board::printBoard = boardPrintBoard
board::margin = 50
board::pieceMargin = 20
board::setGameAbandoned = boardSetGameAbandoned
board::reset = boardReset
board::GAME_RESULT = GAME_RESULT
board::STATE = STATE
board::WINNING_LOCATION = WINNING_LOCATION