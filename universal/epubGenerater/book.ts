export interface Book{
    source:string,
    info:BookInfo
    chapterList:SubTitle[]
}

export interface BookInfo{
    title:string,
    aur:string,
    desc:string,
    pic:string
}

export interface SubTitle{
    title?:string
    chapter:Chapter[]
}

export interface Chapter{
    title:string
    link:string
}

export interface MainBody{
    link:string
    paragraph:Paragraph[]
}

export interface Paragraph{

}

export interface Text extends Paragraph{
    text:string
}

export interface Picture extends Paragraph{
    url:string
}