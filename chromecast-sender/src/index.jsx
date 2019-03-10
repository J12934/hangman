import React from 'react'
import ReactDom from 'react-dom'
import App from './App'
import './style.scss'
import { keyboardPress } from './chromecast-messages'

window.onkeyup = event => {
  if (window.cast.framework.CastContext.getInstance().getCurrentSession() !== null)
    window.cast.framework.CastContext.getInstance().getCurrentSession()
        .sendMessage('urn:x-cast:mi136-hangman', keyboardPress(event))
}

ReactDom.render(
        <App/>,
        document.getElementById('main'))