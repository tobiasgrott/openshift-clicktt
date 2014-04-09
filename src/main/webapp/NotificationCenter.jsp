<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="de.clicktt.*,java.util.List"%><%
   	List<User> users = User.getAllUsers();
%><!DOCTYPE html>
<html>
    <head>
        <title></title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
        <script type="text/javascript">
            $(document).ready(function(){
                
            });
            function sendPushNotification(id){
                var data = $('form#'+id).serialize();
                $('form#'+id).unbind('submit');                
                $.ajax({
                    url: "sendmessage.jsp",
                    type: 'GET',
                    data: data,
                    beforeSend: function() {
                         
                    },
                    success: function(data, textStatus, xhr) {
                          $('.push_message').val("");
                    },
                    error: function(xhr, textStatus, errorThrown) {
                         
                    }
                });
                return false;
            }
        </script>
        <style type="text/css">
             
            h1{
                font-family:Helvetica, Arial, sans-serif;
                font-size: 24px;
                color: #777;
            }
            div.clear{
                clear: both;
            }
             
            textarea{
                float: left;
                resize: none;
            }
             
        </style>
    </head>
    <body>      
        <table  width="910" cellpadding="1" cellspacing="1" style="padding-left:10px;">
         <tr>
           <td align="left">
              <h1>No of Devices Registered: <%= users.size() %></h1>
              <hr/>
           </td>
          </tr> 
          <tr>
            <td align="center">
              <table width="100%" cellpadding="1"
                        cellspacing="1"
                        style="border:1px solid #CCC;" bgcolor="#f4f4f4">
                <tr>
       <%
       	if(users.size() > 0){
       		int i=1;
       		for(User u : users){
       			if(i%3==0){%></tr><tr><td colspan="2"> </td></tr><tr><% }
       			i++;%>
                <td align="left">
                <form id="<%= u.getId() %>" name="" method="post"
                      onSubmit="return sendPushNotification('<%= u.getId() %>')">
                   <label><b>Name:</b> </label> <span><%= u.getName() %></span>
                   <div class="clear"></div>
                   <label><b>Email:</b></label> <span><%= u.getEmail() %></span>
                   <div class="clear"></div>
                   <div class="send_container">                                
                       <textarea rows="3"
                              name="message"
                              cols="25" class="push_message"
                              placeholder="Type push message here"></textarea>
                       <input type="hidden" name="regId"
                                 value="<%= u.getGcmRegId() %>"/>
                       <input type="submit" 
                                 value="Send Push Notification" onClick=""/>
                   </div>
               </form>
            </td>
       <% }
        } else { %> 
              <td>
                User not exist.
               </td>
        <%  } %>
                     
                </tr>
                </table>
            </td>
          </tr>  
        </table>
         
         
    </body>
</html>