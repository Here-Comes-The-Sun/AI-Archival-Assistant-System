<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<link rel="stylesheet" href="sample.css">
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
    <meta charset="UTF-8">
    <title>form</title>
    <style>
        /* 파일 업로드 input 요소 스타일링 */
        .custom-file-input {
            display: inline-block;
            position: relative;
            font-size: 11px;
            color: #fff;
            background-color: #007bff;
            border: none;
            border-radius: 5px;
            padding: 8px 20px;
            cursor: pointer;
            outline: none;
            transition: all 0.3s ease;
            box-shadow: 0 1px 5px rgba(0, 0, 0, 0.25);
        }
        
        .custom-file-input:hover {
            background-color: #0056b3;
        }
        
        .custom-file-input input[type="file"] {
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
            cursor: pointer;
            width: 100%;
            height: 100%;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            height: 100vh;
        }

        .container {
		    width: 60%;
		    background-color: #fff;
		    padding: 30px;
		    border-radius: 5px;
		    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
		    
		}

        h3.title {
		    font-size: 24px;
		    color: gray;
		    text-align: center;
		    padding: 20px;
		    margin-top: -20px; /* Add negative margin to move it upwards */
		}

        fieldset {
            border: none;
            padding: 0;
            margin: 0;
        }

        legend {
            font-weight: bold;
            margin-bottom: 10px;
        }

        table {
            border-collapse: collapse;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.25);
            border-radius: 5px;
            width: 60%;
            margin-top: 20px;
        }

        th, td {
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        input[type="file"] {
            margin-bottom: 10px;
        }

        input[type="text"] {
            width: 60%;
            margin-bottom: 10px;
            padding: 8px;
            box-sizing: border-box;
            border-radius: 5px;
            border: 0px solid #ccc;
            transition: border-color 0.3s ease;
            box-shadow: 0 1px 5px rgba(0, 0, 0, 0.25);
        }
        
        input[type="text"]:focus {
            outline: none;
            box-shadow: grey;
        }

        input[type="submit"], input[type="reset"], input[type="button"] {
            padding: 8px 20px;
            border: none;
            border-radius: 5px;
            background-color: #007bff;
            color: #fff;
            cursor: pointer;
            box-shadow: 0 1px 5px rgba(0, 0, 0, 0.25);   
        }

        input[type="submit"]:hover, input[type="reset"]:hover, input[type="button"]:hover {
            background-color: #0056b3;
        }

        #result {
            margin-top: 20px;
            background-color: #f2f2f2;
            padding: 20px;
            border-radius: 5px;
            display: none;
        }

        #result textarea {
            width: 100%;
            height: 200px;
            resize: none;
        }
        
    </style>
    <script>
        function updateFileInfo() {
            var inputFile = document.querySelector('input[type="file"]');
            var fileInfoTable = document.querySelector('#fileInfoTable');
            var fileTypeCell = fileInfoTable.rows[1].cells[1];
            var fileSizeCell = fileInfoTable.rows[2].cells[1];
            var fileNameDisplay = document.querySelector('#fileNameDisplay');


            if (inputFile.files.length > 0) {
                var selectedFile = inputFile.files[0];
                var fileName = selectedFile.name;
                var fileExtension = fileName.split('.').pop(); // Get file extension
                var fileSizeMB = (selectedFile.size / (1024 * 1024)).toFixed(2); 
                fileNameDisplay.textContent = fileName; // 추가: 파일 이름을 표시

                fileTypeCell.textContent = fileExtension;
                fileSizeCell.textContent = fileSizeMB + " MB";
            } else {
                fileTypeCell.textContent = "";
                fileSizeCell.textContent = "";
                fileNameDisplay.textContent = ""; // 추가: 파일 이름 초기화
            }
        }
        function submitTimestampForm() {
            var searchforInput = document.getElementById('searchforInput');
            var pythonPath = document.getElementById('pythonPath');
            var form = document.getElementById('uploadForm');

            form.elements['searchfor'].value = searchforInput.value;
            form.elements['pythonPath'].value = pythonPath.value;
            form.action = 'timestamp-mnv.do';

            form.submit();
        }
        function submitNoteForm() {
            var pplInput = document.getElementById('pplInput');
            var form = document.getElementById('uploadForm');

            form.elements['ppl'].value = pplInput.value;
            form.action = 'minutes-mnv.do';

            form.submit();
        }
        function submitNoteSummaryForm() {
            var pplInput = document.getElementById('pplInput');
            var form = document.getElementById('uploadForm');

            form.elements['ppl'].value = pplInput.value;
            form.action = 'minutes-summary-mnv.do';

            form.submit();
        }
        document.querySelector('form').addEventListener('submit', function (e) {
            e.preventDefault();
            var formData = new FormData(this);
            
            var buttonClicked = document.activeElement.value;

            var endpoint;
            if (buttonClicked === '타임스탬프 추출') {
                var searchQuery = prompt("Enter search query for timestamp extraction:");
                formData.append('searchfor', searchQuery);
                endpoint = '/timestamp.do';
            } else if (buttonClicked === '요약') {
                endpoint = '/summarize_vid.do';
            } else if (buttonClicked === '태그 추출') {
                endpoint = '/extract-tag.do';
            } else {
                console.error('Unknown button clicked:', buttonClicked);
                return;
            }
            fetch(endpoint, {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                // JSON 데이터를 처리하고 웹 페이지에 표시
                var resultDiv = document.querySelector('#result');
                resultDiv.style.display = 'block'; // 결과 보이기
                resultDiv.textContent = JSON.stringify(data, null, 2);
            })
            .catch(error => {
                console.error('에러 발생:', error);
            });
        });
    </script>
</head>
<body>
<h3 class="title">ARKEEPER</h3>
<div class="container">
    <form method="post" enctype="multipart/form-data" id="uploadForm">

         <fieldset>
       <p>File : 
          <span id="fileNameDisplay"></span>
          <label for="file-upload" class="custom-file-input">Choose File
          <input id="file-upload" type="file" name="file" onchange="updateFileInfo()">
          </label>
      </p>
        <table id="fileInfoTable">
        <tr>
            <th>&nbsp File &nbsp</th>
            <th>&nbsp Info &nbsp</th>
        </tr>
        <tr>
            <td>&nbsp Type &nbsp</td>
            <td id="fileTypeCell"></td>
        </tr>
        <tr>
            <td>&nbsp Size &nbsp</td>
            <td id="fileSizeCell"></td>
        </tr>
         </table>
        <p>
           <input type="submit" value="Summarize" onclick="javascript: form.action='summarize-vid-mnv.do'">
           &nbsp<input type="submit" value="Extract Tags" onclick="javascript: form.action='extract-tag-mnv.do'">
           <%--&nbsp<input type="submit" value="Location" onclick="javascript: form.action='install-guide.do'">--%>
        </p>
        <p>
            Search For : <input type="text" name="searchfor" id="searchforInput" placeholder="키워드를 입력해주세요">&nbsp&nbsp&nbsp
            <%-- Python Path : <input type="text" name="locOfPython" id="pythonPath">&nbsp&nbsp&nbsp --%>
            <input type="button" value="Extract Timestamp" onclick="submitTimestampForm()">
        </p>
        <p>
             회의 참여 인원: <input type="text" name="ppl" id="pplInput" placeholder="회의에 참여한 인원을 입력하세요">&nbsp&nbsp&nbsp
            <%-- Python Path : <input type="text" name="locOfPython" id="pythonPath">&nbsp&nbsp&nbsp --%>
            <input type="button" value="회의록 작성" onclick="submitNoteForm()">
            <input type="button" value="회의록 요약" onclick="submitNoteSummaryForm()">
        </p>
        <%--<p><input type="reset" value="Cancel"></p>--%>
    </fieldset>
        
    </form>

    <div id="result" style="display: none;">
        <textarea rows="10" cols="50"></textarea>
    </div>
</div>
</body>
</html>
