import React from 'react'
import {resetGame} from './chromecast-messages';

export default class App extends React.Component {
    constructor(props) {
      super(props)
		
	  	this.onResetClicked = () => {
        if (window.cast.framework.CastContext.getInstance().getCurrentSession() !== null)
          window.cast.framework.CastContext.getInstance().getCurrentSession()
              .sendMessage('urn:x-cast:mi136-hangman', resetGame())
      }
    }

    render() {
        return <div className="app">
			<div className="castButton">
                <google-cast-launcher></google-cast-launcher>
            </div>
			<button onClick={this.onResetClicked}>New Game</button>
        </div>
    }
}