import * as fs from "fs";

export function writeMetaInfContent(metaDir:string){
    write(`${metaDir}/container.xml`,container())
    
}

function container():string{
    return `<container version="1.0">
        <rootfiles>
            <rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/>
        </rootfiles>
    </container>`
}

function write(file:string,data:any){
    if(!fs.existsSync(file)){
        fs.writeFileSync(file,data)
    }
}