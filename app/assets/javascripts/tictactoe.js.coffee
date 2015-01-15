###*
Copyright (C) 2014 Google Inc. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
###

###*
@fileoverview Tic Tac Toe Gameplay with Chromecast
This file exposes cast.TicTacToe as an object containing a
CastMessageBus and capable of receiving and sending messages
to the sender application.
###

# External namespace for cast specific javascript library
cast = window.cast or {}

# Anonymous namespace
(->

  ###*
  Creates a TicTacToe object.
  @param {board} board an optional game board.
  @constructor
  ###
  TicTacToe = (board) ->
    @mBoard = board
    @mPlayer1 = -1
    @mPlayer2 = -1
    @mCurrentPlayer
    console.log "********TicTacToe********"
    @castReceiverManager_ = cast.receiver.CastReceiverManager.getInstance()
    @castMessageBus_ = @castReceiverManager_.getCastMessageBus(TicTacToe.PROTOCOL, cast.receiver.CastMessageBus.MessageType.JSON)
    @castMessageBus_.onMessage = @onMessage.bind(this)
    @castReceiverManager_.onSenderConnected = @onSenderConnected.bind(this)
    @castReceiverManager_.onSenderDisconnected = @onSenderDisconnected.bind(this)
    @castReceiverManager_.start()
    return
  "use strict"
  TicTacToe.PROTOCOL = "urn:x-cast:com.google.cast.demo.tictactoe"
  TicTacToe.PLAYER =
    O: "O"
    X: "X"


  # Adds event listening functions to TicTacToe.prototype.
  TicTacToe:: =

    ###*
    Sender Connected event
    @param {event} event the sender connected event.
    ###
    onSenderConnected: (event) ->
      console.log "onSenderConnected. Total number of senders: " + @castReceiverManager_.getSenders().length
      return


    ###*
    Sender disconnected event; if all senders are disconnected,
    closes the application.
    @param {event} event the sender disconnected event.
    ###
    onSenderDisconnected: (event) ->
      console.log "onSenderDisconnected. Total number of senders: " + @castReceiverManager_.getSenders().length
      window.close()  if @castReceiverManager_.getSenders().length is 0
      return


    ###*
    Message received event; determines event message and command, and
    choose function to call based on them.
    @param {event} event the event to be processed.
    ###
    onMessage: (event) ->
      message = event.data
      senderId = event.senderId
      console.log "********onMessage********" + JSON.stringify(event.data)
      console.log "mPlayer1: " + @mPlayer1
      console.log "mPlayer2: " + @mPlayer2
      if message.command is "join"
        @onJoin senderId, message
      else if message.command is "leave"
        @onLeave senderId
      else if message.command is "move"
        @onMove senderId, message
      else if message.command is "board_layout_request"
        @onBoardLayoutRequest senderId
      else
        console.log "Invalid message command: " + message.command
      return


    ###*
    Player joined event: registers a new player who joined the game, or
    prevents player from joining if invalid.
    @param {string} senderId the sender the message came from.
    @param {Object|string} message the name of the player who just joined.
    ###
    onJoin: (senderId, message) ->
      console.log "****onJoin****"
      if (@mPlayer1 isnt -1) and (@mPlayer1.senderId is senderId)
        @sendError senderId, "You are already " + @mPlayer1.player + " You aren't allowed to play against yourself."
        return
      if (@mPlayer2 isnt -1) and (@mPlayer2.senderId is senderId)
        @sendError senderId, "You are already " + @mPlayer2.player + " You aren't allowed to play against yourself."
        return
      if @mPlayer1 is -1
        @mPlayer1 = new Object()
        @mPlayer1.name = message.name
        @mPlayer1.senderId = senderId
      else if @mPlayer2 is -1
        @mPlayer2 = new Object()
        @mPlayer2.name = message.name
        @mPlayer2.senderId = senderId
      else
        console.log "Unable to join a full game."
        @sendError senderId, "Game is full."
        return
      console.log "mPlayer1: " + @mPlayer1
      console.log "mPlayer2: " + @mPlayer2
      if @mPlayer1 isnt -1 and @mPlayer2 isnt -1
        @mBoard.reset()
        @startGame_()
      return


    ###*
    Player leave event: determines which player left and unregisters that
    player, and ends the game if all players are absent.
    @param {string} senderId the sender ID of the leaving player.
    ###
    onLeave: (senderId) ->
      console.log "****OnLeave****"
      if @mPlayer1 isnt -1 and @mPlayer1.senderId is senderId
        @mPlayer1 = -1
      else if @mPlayer2 isnt -1 and @mPlayer2.senderId is senderId
        @mPlayer2 = -1
      else
        console.log "Neither player left the game"
        return
      console.log "mBoard.GameResult: " + @mBoard.getGameResult()
      if @mBoard.getGameResult() is -1
        @mBoard.setGameAbandoned()
        @broadcastEndGame @mBoard.getGameResult()
      return


    ###*
    Move event: checks whether a valid move was made and updates the board
    as necessary.
    @param {string} senderId the sender that made the move.
    @param {Object|string} message contains the row and column of the move.
    ###
    onMove: (senderId, message) ->
      console.log "****onMove****"
      isMoveValid = undefined
      if (@mPlayer1 is -1) or (@mPlayer2 is -1)
        console.log "Looks like one of the players is not there"
        console.log "mPlayer1: " + @mPlayer1
        console.log "mPlayer2: " + @mPlayer2
        return
      if @mPlayer1.senderId is senderId
        if @mPlayer1.player is @mCurrentPlayer
          if @mPlayer1.player is TicTacToe.PLAYER.X
            isMoveValid = @mBoard.drawCross(message.row, message.column)
          else
            isMoveValid = @mBoard.drawNaught(message.row, message.column)
        else
          console.log "Ignoring the move. It's not your turn."
          @sendError senderId, "It's not your turn."
          return
      else if @mPlayer2.senderId is senderId
        if @mPlayer2.player is @mCurrentPlayer
          if @mPlayer2.player is TicTacToe.PLAYER.X
            isMoveValid = @mBoard.drawCross(message.row, message.column)
          else
            isMoveValid = @mBoard.drawNaught(message.row, message.column)
        else
          console.log "Ignoring the move. It's not your turn."
          @sendError senderId, "It's not your turn."
          return
      else
        console.log "Ignorning message. Someone other than the current" + "players sent a move."
        @sendError senderId, "You are not playing the game"
        return
      if isMoveValid is false
        @sendError senderId, "Your last move was invalid"
        return
      isGameOver = @mBoard.isGameOver()
      @broadcast
        event: "moved"
        player: @mCurrentPlayer
        row: message.row
        column: message.column
        game_over: isGameOver

      console.log "isGameOver: " + isGameOver
      console.log "winningLoc: " + @mBoard.getWinningLocation()

      # When the game should end
      @broadcastEndGame @mBoard.getGameResult(), @mBoard.getWinningLocation()  if isGameOver is true

      # Switch current player
      @mCurrentPlayer = (if (@mCurrentPlayer is TicTacToe.PLAYER.X) then TicTacToe.PLAYER.O else TicTacToe.PLAYER.X)
      return


    ###*
    Request event for the board layout: sends the current layout of pieces
    on the board through the channel.
    @param {string} senderId the sender the event came from.
    ###
    onBoardLayoutRequest: (senderId) ->
      console.log "****onBoardLayoutRequest****"
      boardLayout = []
      i = 0

      while i < 3
        j = 0

        while j < 3
          boardLayout[i * 3 + j] = @mBoard.mBoard[i][j]
          j++
        i++
      @castMessageBus_.send senderId,
        event: "board_layout_response"
        board: boardLayout

      return

    sendError: (senderId, errorMessage) ->
      @castMessageBus_.send senderId,
        event: "error"
        message: errorMessage

      return

    broadcastEndGame: (endState, winningLocation) ->
      console.log "****endGame****"
      @mPlayer1 = -1
      @mPlayer2 = -1
      @broadcast
        event: "endgame"
        end_state: endState
        winning_location: winningLocation

      return


    ###*
    @private
    ###
    startGame_: ->
      console.log "****startGame****"
      firstPlayer = Math.floor((Math.random() * 10) % 2)
      @mPlayer1.player = (if (firstPlayer is 0) then TicTacToe.PLAYER.X else TicTacToe.PLAYER.O)
      @mPlayer2.player = (if (firstPlayer is 0) then TicTacToe.PLAYER.O else TicTacToe.PLAYER.X)
      @mCurrentPlayer = TicTacToe.PLAYER.X
      @castMessageBus_.send @mPlayer1.senderId,
        event: "joined"
        player: @mPlayer1.player
        opponent: @mPlayer2.name

      @castMessageBus_.send @mPlayer2.senderId,
        event: "joined"
        player: @mPlayer2.player
        opponent: @mPlayer1.name

      return


    ###*
    Broadcasts a message to all of this object's known channels.
    @param {Object|string} message the message to broadcast.
    ###
    broadcast: (message) ->
      @castMessageBus_.broadcast message
      return


  # Exposes public functions and APIs
  cast.TicTacToe = TicTacToe
  return
)()