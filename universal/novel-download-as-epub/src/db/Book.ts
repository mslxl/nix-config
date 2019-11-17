
interface Book{
    name: string
    url: string
    author: string
    cover: ImageLine
    desc: string
    sourceID: string
    category: Category
}


type Category = [Volume]

interface Volume{
    name?: string
    chapters: [Chapter]
}

interface Chapter{
    name: string
    url: string
    content: [ContentLine]
}

interface ContentLine{}

interface TextLine extends ContentLine{
    text:string
}

interface ImageLine extends ContentLine{
    url: string
    base64: string
}