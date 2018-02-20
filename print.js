var s = "L'étude sur la notion de \"famille\" en français, anglais et chinois";
var con = $('.container');
var index = 0;
var length = s.length;
var tId = null;

function start(){
  con.text('');
  
  tId=setInterval(function(){
    con.append(s.charAt(index));
    if(index++ === length){
    clearInterval(tId);
    index = 0;
    start()
    }
  },100);
}

start();