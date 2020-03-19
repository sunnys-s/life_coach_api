import socket from "./socket";

export default class Chat {
    constructor(room, ul, msg, addList) {
      this.room = room;
      this.ul = ul;
      this.msg = msg;
      this.channel = socket.channel(room, {});
      this.addList = addList;
    }
  
    start(){
      this.channel.join(); // join the channel.
  
      this.channel.on('init:msg', (msg) => {
        console.log("kkkkkkk", msg);
        msg.messages.reverse().forEach((m) => {
          this.addList(m);
        });
      })
      
      this.channel.on('new:msg', (msg) => {
        this.addList(msg);
      })
      
      let channel = this.channel;
      this.msg.addEventListener('keypress', function (event) {
        console.log(event.target.value);
        let msg = event.target;
        if (event.keyCode == 13 && msg.value.length > 0) { // don't sent empty msg.
          channel.push('new:msg', { // send the message to the server on "shout" channel
            body: {
              _id: 445,
              createdAt: new Date(),     // get value of "name" of person sending the message
              text: msg.value,
              user: {
                _id: 13
              }
            },
            user: {}
          });
          msg.value = '';         // reset the message input field for next message.
        }
      });
    }
  
    // addList(m){
    //   let li = document.createElement("li"); // create new list item DOM element
    //   let name = m.user._id || 'guest' + m.user._id;    // get name from m or set default
    //   li.innerHTML = '<b>' + name + '</b>: ' + m.text; // set li contents
    //   this.ul.appendChild(li);
    // }
}