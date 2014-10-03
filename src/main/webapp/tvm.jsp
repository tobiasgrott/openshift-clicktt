<%@ page import="de.clicktt.*" language="java"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
Cookie cookies[] = request.getCookies();
Cookie myCookie = null;
boolean auth = false;
if(cookies != null){
	for(Cookie c : cookies){
		if(c.getName().equals("TVMHash") && c.getValue().equals("12703f90fa35bb192432b274665a36f5")){
			auth = true;
		}
	}
}
if(auth){
%>
<!DOCTYPE html>
<html>
<head>
<title>TVM App</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="//code.jquery.com/mobile/1.4.4/jquery.mobile-1.4.4.min.css" />
<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="//code.jquery.com/mobile/1.4.4/jquery.mobile-1.4.4.min.js"></script>
<meta charset="utf-8">
</head>
<body>
	<div data-role="page" id="main">
		<div data-role="header">
			TV Möglingen
			<div class="ui-field-contain">
				<select name="select-native-1" id="teamSelect" onchange="reload()">
					<option value="226372">1. Herren</option>
					<option value="226391">2. Herren</option>
					<option value="230228">3. Herren</option>
					<option value="226469">1. Jungen</option>
					<option value="226381">2. Jungen</option>
				</select>
			</div>
		</div>
		<div role="main" class="ui-content">
			<div data-role="tabs">
				<div data-role="navbar">
					<ul>
						<li><a href="#table" class="ui-btn-active" data-theme="a"
							data-ajax="false">Tabelle</a></li>
						<li><a href="#schedule" data-theme="a" data-ajax="false">Spielplan</a></li>
						<li><a href="#lineup" data-theme="a" data-ajax="false">Aufstellungen</a></li>
						<li><a href="#gym" data-theme="a" data-ajax="false">Hallen</a></li>
						<li><a href="#ttr" data-theme="a" data-ajax="false">TTR</a>
					</ul>
				</div>
				<div id="table" class="ui-content">
					<table data-role="table" id="tabelle" data-mode="columntoggle"
						class="ui-responsive-table-stroke">
						<thead>
							<tr>
								<th>Rang</th>
								<th>Team</th>
								<th>Punkte</th>
							</tr>
						</thead>
					</table>
				</div>
				<div id="schedule" class="ui-content">
					<table data-role="table" id="schedules" data-mode="columntoggle"
						class="ui-responsive-table-stroke">
						<thead>
							<tr>
								<th>Datum</th>
								<th>Partie</th>
								<th>Spiele</th>
							</tr>
						</thead>
					</table>
				</div>
				<div id="lineup" class="ui-content"></div>
				<div id="gym" class="ui-content"></div>
				<div id="ttr" clasS="ui-content">
					<label for="OwnTTR">Eigener TTR:</label>
					<input type="number" id="OwnTTR" /><br />
					<label for="Opp1TTR">Gegner 1 TTR:</label>
					<input type="number" id="Opp1TTR" /><br />
					<label for="Opp1Result">Sieg</label>
					<select id="Opp1Result" data-role="slider"><option value="1">Sieg</option><option value="0">Niederlage</option></select>
					<label for="Opp2TTR">Gegner 2 TTR:</label>
					<input type="number" id="Opp2TTR" /><br />
					<label for="Opp2Result">Sieg</label>
					<select id="Opp2Result" data-role="slider"><option value="1">Sieg</option><option value="0">Niederlage</option></select>
					<button onClick="calculateTTR()">Berechnen</button>
					<div id="Result"></div>					
				</div>
			</div>
		</div>
		<div data-role="footer"></div>
	</div>
	<script type="text/javascript">
	    function calculateTTR(){
	    	var ownTTR = $("#OwnTTR").val();
	    	var opp1TTR = $("#Opp1TTR").val();
	    	var opp2TTR = $("#Opp2TTR").val();
	    	var result1 = $("#Opp1Result").val();
	    	var result2 = $("#Opp2Result").val();
	    	var spiele = 0;
	    	var siege = 0;
	    	var prob1=0;
	    	var prob2=0;
	    	var prob = 0;
	    	var probability = 0;
	    	var t = document.createElement("table");
	    	var tr = document.createElement("tr");
	    	var	th = document.createElement("th");
	    	th.appendChild(document.createTextNode("Spiel"));
	    	tr.appendChild(th);
	    	th = document.createElement("th");
	    	th.appendChild(document.createTextNode("Sieg"));
	    	tr.appendChild(th);
	    	th = document.createElement("th");
	    	th.appendChild(document.createTextNode("Chance"));
	    	tr.appendChild(th);
	    	th = document.createElement("th");
	    	th.appendChild(document.createTextNode("Punkte"));
	    	tr.appendChild(th);
	    	t.appendChild(tr);
			var td;
	    	if(opp1TTR>0){
	    		spiele++;
	    		prob1 = 1.0 / (1.0 + Math.pow(10,((opp1TTR-ownTTR)/150.0)));
	    		tr = document.createElement("tr");
	    		td = document.createElement("td");
	    		td.appendChild(document.createTextNode("Spiel 1"));
	    		tr.appendChild(td);
	    		td = document.createElement("td");
	    		if(result1 == 0){
	    			td.appendChild(document.createTextNode("Nein"));
	    		}else{
	    			td.appendChild(document.createTextNode("Ja"));
	    			siege++;
	    		}
	    		tr.appendChild(td);
	    		td = document.createElement("td");
	    		td.appendChild(document.createTextNode(Math.round(prob1*100)+" %"));
	    		tr.appendChild(td);
	    		td = document.createElement("td");
	    		td.appendChild(document.createTextNode(Math.round((result1-prob1)*16)));
	    		tr.appendChild(td);
	    		t.appendChild(tr);
	    	}
	    	if(opp2TTR>0){
	    		spiele++;
	    		prob2 = 1.0 / (1.0 + Math.pow(10,((opp2TTR-ownTTR)/150.0)));
	    		tr = document.createElement("tr");
	    		td = document.createElement("td");
	    		td.appendChild(document.createTextNode("Spiel 2"));
	    		tr.appendChild(td);
	    		td = document.createElement("td");
	    		if(result2 == 0){
	    			td.appendChild(document.createTextNode("Nein"));
	    		}else{
	    			td.appendChild(document.createTextNode("Ja"));
	    			siege++;
	    		}
	    		tr.appendChild(td);
	    		td = document.createElement("td");
	    		td.appendChild(document.createTextNode(Math.round(prob2*100)+" %"));
	    		tr.appendChild(td);
	    		td = document.createElement("td");
	    		td.appendChild(document.createTextNode(Math.round((result2-prob2)*16)));
	    		tr.appendChild(td);
	    		t.appendChild(tr);
	     	}
	     	if(spiele == 2){
	    		var prob = prob1 + prob2;
	    		tr = document.createElement("tr");
	    		td = document.createElement("td");
	    		td.appendChild(document.createTextNode("Gesamt"));
	    		tr.appendChild(td);
	    		td = document.createElement("td");
	    		td.appendChild(document.createTextNode(siege));
	    		tr.appendChild(td);
	    		td = document.createElement("td");
	    		td.appendChild(document.createTextNode(Math.round(prob*100)+" %"));
	    		tr.appendChild(td);
	    		td = document.createElement("td");
	    		td.appendChild(document.createTextNode(Math.round((siege-prob)*16)));
	    		tr.appendChild(td);
	    		t.appendChild(tr);
	     	}
	    	$("#Result").empty();
	    	$("#Result").append(t);
	    }
		function reload() {
			console.log($("#teamSelect").val());
			$.getJSON("json/table.jsp?id=" + $("#teamSelect").val(), function(
					data) {
				var items = [];
				for (i = 0; i < data.length; i++) {
					if (data[i].Team.indexOf("TV MÃ¶glingen") > -1) {
						items.push("<tr class=\"tvm\"><th>" + data[i].Rang
								+ "</th><td>" + data[i].Team + "</td><td>"
								+ data[i].Punkte + "</td></tr>");
					} else {
						items.push("<tr><th>" + data[i].Rang + "</th><td>"
								+ data[i].Team + "</td><td>" + data[i].Punkte
								+ "</td></tr>");
					}
				}
				$("#tabelle tbody").remove();
				$("<tbody/>", {
					"class" : "my-new-list",
					html : items.join("")
				}).appendTo("#tabelle");
				$("#tabelle").table("refresh");
			});
			$.getJSON(
							"json/schedule.jsp?id=" + $("#teamSelect").val(),
							function(data) {
								var items = [];
								$("#schedules tbody").remove();
								for (i = 0; i < data.length; i++) {
									if (data[i].Heimmannschaft
											.indexOf("TV Möglingen") > -1
											|| data[i].Gastmannschaft
													.indexOf("TV Möglingen") > -1) {
										items.push("<tr class=\"tvm\"><th>"
												+ data[i].Tag + " "
												+ data[i].Datum + " "
												+ data[i].Zeit + "<br />"
												+ data[i].Halle + "</td><td>"
												+ data[i].Heimmannschaft
												+ "<br />"
												+ data[i].Gastmannschaft
												+ "</td><td>" + data[i].Spiele
												+ "</td></tr>");
									} else {
										items.push("<tr><th>" + data[i].Tag
												+ " " + data[i].Datum + " "
												+ data[i].Zeit + "<br />"
												+ data[i].Halle + "</td><td>"
												+ data[i].Heimmannschaft
												+ "<br />"
												+ data[i].Gastmannschaft
												+ "</td><td>" + data[i].Spiele
												+ "</td></tr>");
									}
								}
								$("<tbody/>", {
									"class" : "my-new-list",
									html : items.join("")
								}).appendTo("#schedules");
								$("#schedules").table("refresh");
							});
			$.getJSON("json/lineup.jsp?id=" + $("#teamSelect").val(), function(
					data) {
				$("#lineups").empty();
				var ul = document.createElement("ul");
				ul.setAttribute("id", "lineups");
				ul.setAttribute("data-role", "listview");
				ul.setAttribute("data-inset", "true");
				ul.setAttribute("data-divider-theme", "a");
				$("#lineup").append(ul);
				for (i = 0; i < data.length; i++) {
					var li = document.createElement("li");
					li.setAttribute("data-role", "list-divider");
					li.appendChild(document.createTextNode(data[i].Team));
					$("#lineups").append(li);
					for (j = 0; j < data[i].LineUp.length; j++) {
						var lic = document.createElement("li");
						lic.appendChild(document
								.createTextNode(data[i].LineUp[j].Rang + " "
										+ data[i].LineUp[j].Name + " ("
										+ data[i].LineUp[j].TTR + ")"));
						$("#lineups").append(lic);
					}
				}
				$('#lineups').listview();
				$('#lineups').listview('refresh');
			});
			$.getJSON("json/gyms.jsp?id="+ $("#teamSelect").val(), function(data){
				$("#gyms").empty();
				var ul = document.createElement("ul");
				ul.setAttribute("id","gyms");
				ul.setAttribute("data-role", "listview");
				ul.setAttribute("data-inset", "true");
				ul.setAttribute("data-divider-theme", "a");
				$("#gym").append(ul);
				for(i = 0;i< data.length; i++){
					var li = document.createElement("li");
					li.setAttribute("data-role","list-divider");
					li.appendChild(document.createTextNode(data[i].Team));
					$("#gyms").append(li);
					for(j = 0;j<data[i].Hallen.length;j++){
						var lic = document.createElement("li");
						lic.appendChild(document.createTextNode(data[i].Hallen[j].Nr));
						lic.appendChild(document.createElement("br"));
						lic.appendChild(document.createTextNode(data[i].Hallen[j].Name));
						lic.appendChild(document.createElement("br"));
						lic.appendChild(document.createTextNode(data[i].Hallen[j].Strasse));
						lic.appendChild(document.createElement("br"));
						lic.appendChild(document.createTextNode(data[i].Hallen[j].Ort));
						lic.setAttribute("onclick","geo('"+data[i].Hallen[j].Strasse+", "+data[i].Hallen[j].Ort+"')");
						$("#gyms").append(lic);
					}
				}
				$("#gyms").listview();
				$("#gyms").listview("refresh");
			});
		}
		function geo(data){
			document.location.href = "geo:0,0?q="+data;
		}
		$(document).ready(function() {
			reload();
		});
	</script>
	<style text="text/css">
#schedules tbody tr:nth-child(odd), #tabelle tbody tr:nth-child(odd) {
	background-color: #eeeeee;
}

#schedules tbody tr.tvm, #tabelle tbody tr.tvm {
	background-color: blue;
	color: white;
}
</style>
</body>
</html>
<%
}else{
%>
<!DOCTYPE html>
<html>
	<head>
		<title>TVM</title>
	</head>
	<body>
		<p>Not Authorized</p>
	</body>
</html>
<%
} %>