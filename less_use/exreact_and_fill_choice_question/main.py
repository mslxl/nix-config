from functools import reduce
import re
import os
import json
import tempfile
import requests


REGEX_QUESTION = re.compile(
    r"\s*?((\d+)、?.*?D(?=.)[^\n]*?$)", re.IGNORECASE | re.DOTALL | re.MULTILINE | re.UNICODE)
REGEX_ANSWER = re.compile(
    r"(\d+)(?:.*?)([ABCD]+)", re.IGNORECASE | re.DOTALL | re.MULTILINE | re.UNICODE)
REGEX_BRACKET = re.compile(
    r"[\(（](.*?)[\)）]", re.DOTALL | re.MULTILINE | re.UNICODE)

configFile = os.path.join(os.path.dirname(__file__), "config.json")
config = json.loads(open(configFile, "r", encoding="UTF-8").read())

answerFormatText = "({{c1::%s}})" if config['ankiClozeFormat'] else "(%s)"


def tempFile(comment: str) -> str:
    _, file = tempfile.mkstemp(".txt")
    with open(file, "w") as f:
        f.write(comment)
        f.flush()
        f.close()
    userEdit(file)
    return file


def is_continious(lst) -> bool:
    tmp = list(lst)
    for (fst, snd) in zip(tmp, tmp[1:]):
        if snd - fst != 1:
            return False
    return True


def userEdit(f):
    print("Edit file " + f)
    os.system(config['editor'] % (f))


def matchFileContent(fileToRead, regex):
    text = open(fileToRead, encoding=config['encode']).read()
    return regex.findall(text)


def assert_msg(expr, msg):
    if not expr:
        raise RuntimeError(msg)


def main():
    fileQuest = tempFile(
        "# Replace this content with question text") if config['input'] == "edit" else config['inputQuestFile']
    fileAns = tempFile(
        "# Replace this content with answer text") if config['input'] == "edit" else config['inputAnsFile']

    question = matchFileContent(fileQuest, REGEX_QUESTION)
    answer = matchFileContent(fileAns, REGEX_ANSWER)

    assert_msg(is_continious(map(lambda t: int(
        t[1]), question)), "Parser question error, the number is not continous")
    assert_msg(is_continious(map(lambda t: int(
        t[0]), answer)), "Parser ans error, the number is not continous")

    question = list(map(lambda x: x[0].strip() + "\n", question))
    answer = list(map(lambda x: x[1].strip(), answer))

    assert_msg(len(question) == len(answer),
               "The number of question doesn't match the number of answer")

    result = [REGEX_BRACKET.sub(answerFormatText % (a), q)
              for (q, a) in zip(question, answer)]

    if config['target'] == 'dir':
        outputFile = os.path.join(
            config['outputDir'], str(hash(str(result))) + ".txt")
        dirname = os.path.dirname(outputFile)
        if not os.path.exists(dirname):
            os.makedirs(dirname)
        with open(outputFile, "w+", encoding=config['encode']) as f:
            for i in result:
                f.write(i)
                f.write("\n---\n")
            f.flush()
            f.close()
    elif config["target"] == "console":
        for i in result:
            print(i)
    elif config["target"] == "anki":
        notes = [
            {
                "deckName": config['anki']['deck'],
                "modelName": "Cloze",
                "tags": config['anki']['tags'],
                "fields": {
                    "Text": content.replace("\n", "</br>"),
                    "Back Extra": ""
                }
            } for content in result]

        response = requests.post(config['anki']['address'], json={
            "action": "canAddNotes",
            "version": 6,
            "params": {
                "notes": notes
            },
        }).json()
        if response['error'] is not None:
            raise RuntimeError(response['error'])

        response = requests.post(config['anki']['address'], json={
            "action": "addNotes",
            "version": 6,
            "params": {
                "notes": notes
            }
        }).json()
        print(response)
        print("Done")

main()
while config['loop'] and config['input'] == "edit":
    main()