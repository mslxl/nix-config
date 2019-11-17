import {ipcRenderer,remote} from 'electron'
const {dialog} = remote



console.log('hello,world')
$(document).ready(()=>{
    $('.dashboard').hide()
    $('.dir-choose').click(async ()=>{
        let paths = <any>await dialog.showOpenDialog({
            properties:['openDirectory']
        })
        if(paths){
            $('.dir-path').attr('value',paths[0])
        }
    })
    $('.dir-load').click(()=>{
        ipcRenderer.send('file:load',$('.dir-path').val())
    })
})

function log(level: ('info'|'err'|'succ'|'warn'),msg:string){
    const map = {
        'info':'alert alert-info',
        'err':'alert alert-danger',
        'succ':'alert alert-success',
        'warn':'alert alert-warning'
    }
    let elem = $(`<li class='${map[level]}' role='alert'></li>`).text(msg)
    $('.info-box').append(elem)
}

ipcRenderer.on('log',(event,le,msg)=>{
    log(le,msg)
})