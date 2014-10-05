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
		<link rel="stylesheet" href="//code.jquery.com/mobile/1.4.4/jquery.mobile-1.4.4.min.css" />
		<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
		<script src="//code.jquery.com/mobile/1.4.4/jquery.mobile-1.4.4.min.js"></script>
		<meta charset="utf-8">
		<script type="text/javascript">
			// Global Variables
			var teamId = null;
		</script>
	</head>
<body>
				<div data-role="panel" id="menu" data-display="push" data-position="left" data-theme="a">
			<ul data-role="listview" data-inset="false" data-shadow="false">
				<li data-inset="false"><a href="#Newsfeed">Newsfeed</a></li>
				<li data-role="collapsible" data-iconpos="right" data-inset="false">
					<h2>Teams</h2>
					<ul data-role="listview" data-theme="a">
						<li><a href="javascript:teamNavigate(226372)">1.Herren</a></li>
						<li><a href="javascript:teamNavigate(226391)">2.Herren</a></li>
						<li><a href="javascript:teamNavigate(230228)">3.Herren</a></li>
						<li><a href="javascript:teamNavigate(226469)">1.Kids</a></li>
						<li><a href="javascript:teamNavigate(226381)">2.Kids</a></li>
					</ul>
				</li>
				<li data-inset="false"><a href="#TTR">TTR-Rechner</a></li>
			</ul>
		</div>
	<div data-role="page" id="Newsfeed">
		<div data-role="header">
			TV Möglingen Newsfeed
		</div>
		<div data-role="main" class="ui-content">
			<h2>Rückblick</h2>
			<div id="backlog" class="ui-content">
				<table data-role="table" id="backlogs" data-mode="columntoggle"
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
			<div id="preview" class="ui-content">
				<table data-role="table" id="previews" data-mode="columntoggle"
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
		</div>
	</div>
	
	<div data-role="page" id="TTR">
		<div data-role="header">
			TV Möglingen TTR Calculator
		</div>
		<div data-role="main" class="ui-content">
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
	
	<div data-role="page" id="Team">
		<div data-role="header">
			TV Möglingen <span id="pageTitle" />
			<div data-role="tabs">
				<div data-role="navbar">
					<ul>
						<li><a onclick="tvmshow('table')" class="ui-btn-active" data-theme="a"
							data-ajax="false">Tabelle</a></li>
						<li><a onclick="tvmshow('schedule')" data-theme="a" data-ajax="false">Spielplan</a></li>
						<li><a onclick="tvmshow('lineup')" data-theme="a" data-ajax="false">Aufstellungen</a></li>
						<li><a onclick="tvmshow('gym')" data-theme="a" data-ajax="false">Hallen</a></li>
					</ul>
				</div>
			</div>
		<div role="main" class="ui-content">
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
		</div>
	</div>
	<script type="text/javascript">
		function teamNavigate(id){
			teamId = id;
			reload();
			$.mobile.navigate("#Team");
			tvmshow('table');
		}
		function tvmshow(id){
			$("#gym").hide();
			$("#table").hide();
			$("#lineup").hide();
			$("#schedule").hide();
			$("#"+id).show();
		}
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
			console.log(teamId);
			if(teamId!=null){
			$.getJSON(
			"json/table.jsp?id=" + teamId, function(
					data) {
				var items = [];
				for (i = 0; i < data.length; i++) {
					if (data[i].Team.indexOf("TV Möglingen") > -1) {
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
							"json/schedule.jsp?id=" + teamId,
							function(data) {
								var items = [];
								$("#schedules tbody").remove();
								for (i = 0; i < data.length; i++) {
									if (data[i].Heimmannschaft
											.indexOf("TV Möglingen") > -1
											|| data[i].Gastmannschaft
													.indexOf("TV Möglingen") > -1) {
											var str;
										if(data[i].Details==true){
											str = "<tr class=\"tvm\" onclick=\"window.open('http://ttvwh.click-tt.de"+data[i].Detailslink+"')\">";
										}else{
											str = "<tr class=\"tvm\">";
										}
										str += "<th>" + data[i].Tag
												+ " " + data[i].Datum + " "
												+ data[i].Zeit + "<br />"
												+ data[i].Halle + "</td><td>"
												+ data[i].Heimmannschaft
												+ "<br />"
												+ data[i].Gastmannschaft
												+ "</td><td>" + data[i].Spiele
												+ "</td></tr>";
										items.push(str);

									} else {
										var str;
										if(data[i].Details==true){
											str = "<tr onclick=\"window.open('http://ttvwh.click-tt.de"+data[i].Detailslink+"')\">";
										}else{
											str = "<tr>";
										}
										str += "<th>" + data[i].Tag
												+ " " + data[i].Datum + " "
												+ data[i].Zeit + "<br />"
												+ data[i].Halle + "</td><td>"
												+ data[i].Heimmannschaft
												+ "<br />"
												+ data[i].Gastmannschaft
												+ "</td><td>" + data[i].Spiele
												+ "</td></tr>";
										items.push(str);
									}
								}
								$("<tbody/>", {
									"class" : "my-new-list",
									html : items.join("")
								}).appendTo("#schedules");
								$("#schedules").table("refresh");
							});
			$.getJSON(
			"json/lineup.jsp?id=" + teamId, function(
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
						lic.setAttribute("onclick","window.open('http://ttvwh.click-tt.de"+data[i].LineUp[j].Details+"')");
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
			$.getJSON("json/gyms.jsp?id="+ teamId, function(data){
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
			$.getJSON("json/news.jsp",function(data) {
				var items = [];
				$("#previews tbody").remove();
				$("#backlogs tbody").remove();
				for (i = 0; i < data.Backlog.length; i++) {
					var str;
					if(data.Backlog[i].Details==true){
						str = "<tr onclick=\"window.open('http://ttvwh.click-tt.de"+data.Backlog[i].Detailslink+"')\">";
					}else{
						str = "<tr>";
					}
					str += "<th>" + data.Backlog[i].Tag
							+ " " + data.Backlog[i].Datum + " "
							+ data.Backlog[i].Zeit + "<br />"
							+ data.Backlog[i].Halle + "</td><td>"
							+ data.Backlog[i].Heimmannschaft
							+ "<br />"
							+ data.Backlog[i].Gastmannschaft
							+ "</td><td>" + data.Backlog[i].Spiele
							+ "</td></tr>";
					items.push(str);
				}
				$("<tbody/>", {
					"class" : "my-new-list",
					html : items.join("")
				}).appendTo("#backlogs");
				$("#backlogs").table("refresh");
				items = [];
				for (i = 0; i < data.Preview.length; i++) {
					var str;
					str += "<tr><th>" + data.Preview[i].Tag
							+ " " + data.Preview[i].Datum + " "
							+ data.Preview[i].Zeit + "<br />"
							+ data.Preview[i].Halle + "</td><td>"
							+ data.Preview[i].Heimmannschaft
							+ "<br />"
							+ data.Preview[i].Gastmannschaft
							+ "</td><td>&nbsp;</td></tr>";
					items.push(str);
				}
				$("<tbody/>", {
					"class" : "my-new-list",
					html : items.join("")
				}).appendTo("#previews");
				$("#previews").table("refresh");

			});
		}
		
		function geo(data){
			document.location.href = "geo:0,0?q="+data;
		}
		$(document).ready(function() {
			reload();
			$("body>[data-role='panel']").panel();
			$("ul[data-role='listview']").listview();
			$("li[data-role='collapsible']").collapsible();
			$(document).on("swipeleft swiperight", "#Newsfeed", function(e){
				if($(".ui-page-active").jqmData("panel") !== "open"){
					if(e.type === "swiperight"){
						$("#menu").panel("open");
					}
				}
			});
			$(document).on("swipeleft swiperight", "#Team", function(e){
				if($(".ui-page-active").jqmData("panel") !== "open"){
					if(e.type === "swiperight"){
						$("#menu").panel("open");
					}
				}
			});
			$(document).on("swipeleft swiperight", "#TTR", function(e){
				if($(".ui-page-active").jqmData("panel") !== "open"){
					if(e.type === "swiperight"){
						$("#menu").panel("open");
					}
				}
			});
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
.ui-li-static.ui-collapsible > .ui-collapsible-heading {
	margin: 0;
}
.ui-li-static.ui-collapsible{
padding:0;
}
.ui-li-static.ui-collapsible > .ui-collapsible-heading > .ui-btn {
	border-top-width: 0;
}
.ui-li-static.ui-collapsible > .ui-collapsible-heading.ui-collapsible-heading-collapsed > .ui-btn,
.ui-li-static.ui-collapsible > .ui-collapsible-content{
		border-bottom-width: 0;
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