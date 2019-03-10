export const KEYBOARD_PRESS = 'KEYBOARD_PRESS'
export const keyboardPress = keyPressEvent => ({type: KEYBOARD_PRESS, payload: { keyCode: keyPressEvent.keyCode }})

export const RESET_GAME = 'RESET_GAME'
export const resetGame = () => ({type: RESET_GAME})