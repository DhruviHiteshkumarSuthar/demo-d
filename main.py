from fastapi import FastAPI, UploadFile, File
from tika import parser
import os

app = FastAPI()

def extract_text_from_pdf(pdf_path):
    parsed_pdf = parser.from_file(pdf_path)
    return parsed_pdf['content']

@app.post("/upload-pdf/")
async def upload_pdf(file: UploadFile = File(...)):
    os.makedirs("temp", exist_ok=True)  # Ensure the 'temp' directory exists
    file_location = f"temp/{file.filename}"
    with open(file_location, "wb+") as file_object:
        file_object.write(file.file.read())
    text = extract_text_from_pdf(file_location)
    return {"content": text}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

# from fastapi import FastAPI, UploadFile, File, HTTPException
# from tika import parser
# import os
# import shutil

# app = FastAPI()

# def extract_text_from_pdf(pdf_path):
#     try:
#         parsed_pdf = parser.from_file(pdf_path)
#         return parsed_pdf['content']
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error parsing PDF: {e}")

# @app.post("/upload-pdf/")
# async def upload_pdf(file: UploadFile = File(...)):
#     os.makedirs("temp", exist_ok=True)  # Ensure the 'temp' directory exists
#     file_location = f"temp/{file.filename}"
#     try:
#         with open(file_location, "wb+") as file_object:
#             shutil.copyfileobj(file.file, file_object)
#         text = extract_text_from_pdf(file_location)
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error processing file: {e}")
#     finally:
#         os.remove(file_location)  # Clean up the temporary file
#     return {"content": text}

# if __name__ == "__main__":
#     import uvicorn
#     uvicorn.run(app, host="0.0.0.0", port=8000)
