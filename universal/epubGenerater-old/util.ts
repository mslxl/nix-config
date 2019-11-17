import * as readline from 'readline'
import * as fs from 'fs';

export async function question(qurey: string): Promise<string> {
    return new Promise<string>((resolve, reject) => {
        const rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });
        rl.question(qurey, resolve)
    })
}

export function repeat(times: number, func: (cur: number) => void) {
    for (let i = 1; i <= times; i++) {
        func(i)
    }
}

export function hashCode(str: string) {
    let hash = 0;
    if (str.length == 0) return hash;
    for (let i = 0; i < str.length; i++) {
        let char = str.charCodeAt(i);
        hash = ((hash<<5)-hash)+char;
        hash = hash & hash; // Convert to 32bit integer
    }
    return hash;
}

// export module fsp {
//     export async function read(name: string): Promise<string> {
//         return new Promise((resolve, rejects) => {
//             fs.readFile(name, (err, data) => {
//                 if (err != null) {
//                     resolve(data.toString())
//                 } else {
//                     rejects(err)
//                 }
//             })
//         })
//     }
//     export async function mkdir(name: string): Promise<void> {
//         return new Promise((resolve, rejects) => {
//             fs.mkdir(name, err => {
//                 if (err == null) {
//                     resolve()
//                 } else {
//                     rejects(err)
//                 }
//             })
//         })
//     }
//     export async function write(name: string, data: string): Promise<void> {
//         return new Promise((resolve, rejects) => {
//             fs.writeFile(name,data,err=>{
//                 if (err == null) {
//                     resolve()
//                 } else {
//                     rejects(err)
//                 }
//             })
//         })
//     }
//     export async function exists(name: string): Promise<boolean> {
//         return new Promise((resolve, rejects) => {
//             fs.exists(name,e=>{
//                 resolve(e)
//             })
//         })
//     }

// }