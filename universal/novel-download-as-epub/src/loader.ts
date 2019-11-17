import * as fs from 'fs-extra'
import * as path from 'path'
export module Downloader{
    export class Project{
        path: string;
        constructor(path: string){
            this.path = path
        }
    }
    export function load(p: string):Project{
        if(!fs.existsSync(p)){
            fs.mkdirsSync(p)
        }else if(!fs.existsSync(path.join(p,'project.json'))){
            fs.createFileSync(path.join(p,'project.json'))
        }
        return new Project(p)
    }
}