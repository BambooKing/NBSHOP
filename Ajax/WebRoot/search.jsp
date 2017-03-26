<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Ajax一下</title>


<style type="text/css">
#mydiv {
	position: absolute;
	left: 50%;
	top: 50%;
	margin-left: -200px;
	margin-top: -50px;
}

.mouseOver {
	background: #708090;
	color: #FFFAFA;
}

.mouseOut {
	background: #FFFAFA;
	color: #000000;
}
</style>
</head>
<body>
	<div id="mydiv">
		<input type="text" id="keyword" size="50" onkeyup="getMoreContents()" onblur="keywordblur()" onfocus="getMoreContents()" /> <input
			type="button" value="搜索一下" width="50px" />
		<!-- 下面是内容展示的区域 -->
		<div id="popDiv">
			<table id="content_table" bgcolor="#FFFAFA" border="0" cellspacing="0" cellpadding="0">
				<tbody id="content_table_body">
					<!-- 动态查询出的数据显示的位置 -->

				</tbody>
			</table>
		</div>
	</div>




	<script type="text/javascript">
		//获得用户输入内容的关联信息的函数
		function getMoreContents() {
			//首先获得用户的输入
			var content = document.getElementById("keyword").value;
			if (content == "") {
				clearContent();
				return;
			}
			//向服务器发送输入数据			
			var xmlHttp = createXMLHttp();

			var url = "search?keyword=" + escape(content);
			//true表示异步请求,js脚本会在send()方法之后继续执行，而不会等待来自服务器的响应
			xmlHttp.open("GET", url, true);
			xmlHttp.send(null);
			//xmlHttp绑定回调方法,回调方法会在xmlHttp状态改变时被调用
			//xmlHttp的状态为0-4，只关心4（完成complete）的状态
			xmlHttp.onreadystatechange = function() {
				if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
					var result = xmlHttp.responseText;
					//JSON.parse()能否使用???
					var json = eval("(" + result + ")");
					setContent(json);

				}
			}

		}

		function createXMLHttp() {
			var xmlHttp;
			if (window.XMLHttpRequest) {
				xmlHttp = new XMLHttpRequest();
			}
			if (window.ActiveXObject) {
				xmlHttp = new ActiveObject("Microsoft.XMLHTTP");
				if (!xmlHttp) {
					xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
				}
			}
			return xmlHttp;

		}

		//设置数据的展示
		function setContent(contents) {
			//输入其他数据后清空展示数据
			clearContent();
			//设置位置
			setLocation();
			//获得数据的个数
			var size = contents.length;
			for (var i = 0; i < size; i++) {
				var nextNode = contents[i]; //代表的是json格式数据的第i个元素
				var tr = document.createElement("tr");
				var td = document.createElement("td");
				td.setAttribute("border", "0");
				td.setAttribute("bgcolor", "#FFFAFA");
				//鼠标经过
				td.onmouseover = function() {
					this.className = 'mouseOver';
				};
				//鼠标移开
				td.onmouseout = function() {
					this.className = 'mouseOut';
				};
				//鼠标点击时,数据填充到输入框(数据绑定)
				td.onclick = function() {
					document.getElementById("keyword").innerHTML(this.value);
				};
				var text = document.createTextNode(nextNode);
				td.appendChild(text);
				tr.appendChild(td);
				document.getElementById("content_table_body").appendChild(tr);

			}
		}

		//清除输入后展示数据
		function clearContent() {
			var contentTableBody = document
					.getElementById("content_table_body");
			var size = contentTableBody.childNodes.length;
			for (var i = size - 1; i >= 0; i--) {
				contentTableBody.removeChild(contentTableBody.childNodes[i]);
			}
			
			/* document.getElementById("popDiv").style.border="0"; */
			document.getElementById("popDiv").style.border="none";

		}

		//输入框失去焦点时清空contents
		function keywordblur() {
			clearContent();
		}
		//设置显示关联信息的位置
		function setLocation(){
			//关联信息的大小和输入框大小一致
			var content = document.getElementById("keyword");
			var width = content.offsetWidth;
			var left = content["offsetLeft"]; //距离左边框的距离
			var top = content["offsetTop"]+content.offsetHeight; //到顶部的距离
			//获得显示数据的DIV
			var popDiv = document.getElementById("popDiv");
			popDiv.style.border="black 1px solid";
			popDiv.style.left = left+"px";
			popDiv.style.top = top+"px";
			popDiv.style.width = width +"px";
			document.getElementById("content_table").style.width = width+"px";
		}
	</script>

</body>
</html>