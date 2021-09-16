# ScrollSnake
What if scroll bars on the iPhone X worked like the game “Snake”?

This very silly thing is a response to [this Tweet](https://twitter.com/vojtastavik/status/907911237983449088/video/1) by [Vojta Stavik](https://twitter.com/vojtastavik).

![Screen recording of the iPhone X simulator with the sensor bar ("notch") on the right. As a table view scrolls, the scroll bar bends and contorts itself around the sensor bar. It kind of looks like a game of Snake.](ScrollSnake.gif)

Note: this project is hardcoded to the screen dimensions and sensor housing size of iPhone X/Xs/11 Pro. To support any other devices, the specific sizes in `viewDidLayoutSubviews` would need to be adjusted.
