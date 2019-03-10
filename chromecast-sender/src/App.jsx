import React from 'react'
import {resetGame, keyboardPress} from './chromecast-messages';
import Keyboard from 'react-simple-keyboard';
import 'react-simple-keyboard/build/css/index.css';
import keycode from 'keycode';

export default class App extends React.Component {
    constructor(props) {
      super(props)
		
	  	this.onResetClicked = () => {
        if (window.cast.framework.CastContext.getInstance().getCurrentSession() !== null)
          window.cast.framework.CastContext.getInstance().getCurrentSession()
              .sendMessage('urn:x-cast:mi136-hangman', resetGame())
      }
      this.onKeyPress = (button) => {
        if (window.cast.framework.CastContext.getInstance().getCurrentSession() !== null)
          window.cast.framework.CastContext.getInstance().getCurrentSession()
            .sendMessage('urn:x-cast:mi136-hangman', keyboardPress({ keyCode: keycode(button) }))
      }
    }

    render() {
        return <div className="app">
                <div className="castButton">
                  <google-cast-launcher></google-cast-launcher>
                </div>
                <div className="resetButton">
                  <button onClick={this.onResetClicked}>New Game</button>
                </div>
                 <Keyboard
                  onKeyPress={button =>
                    this.onKeyPress(button)}
                />
                </div>
    }
}