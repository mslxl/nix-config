import * as fs from 'fs-extra'
import { series, parallel, src, dest,watch } from 'gulp'
import * as pug from 'gulp-pug'
import * as ts from 'gulp-typescript'

function clean(cb: any) {
    try {
        if (fs.existsSync('build')) {
            fs.removeSync('build')
        }
    } catch (e) {
        cb(e)
    }

    cb()
}

function buildPug() {
    return src('view/**/*.pug')
        .pipe(pug())
        .pipe(dest('build/'))
}

function buildTs() {
    let config = fs.readJSONSync('tsconfig.json').compilerOptions
    return src('src/**/*.ts')
        .pipe(src('view/**/*.ts'))
        .pipe(ts(config))
        .pipe(dest('build/'))
}

function copyLib(cb: any) {
    src('node_modules/bootstrap/dist/**/*.min.*').pipe(dest('build/bootstrap/'))
    cb()
}

function copyFile() {
    return src(['src/**/*', 'view/**/*', '!**/*.ts', '!**/*.pug'])
        .pipe(dest('build/'))
}

const build = parallel(buildPug, buildTs, copyLib, copyFile)

exports.watch = (cb:any)=>{
    watch(['src/**/*.ts','view/**/*.ts'],buildTs)
    watch('view/**/*.pug',buildPug)
    cb()
}

exports.build = build
exports.buildPug = buildPug
exports.buildTs = buildTs
exports.default = series(clean, build)