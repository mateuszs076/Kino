<%-- 
    Document   : test
    Created on : 2018-05-03, 19:19:01
    Author     : Arekl
--%>

<%@page import="org.apache.jasper.tagplugins.jstl.ForEach"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Kino.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Seanse</title>
        <link rel="stylesheet" href="../../styles/jquery.dataTables.min.css">
        <link rel="stylesheet" href="../../styles/jquery-ui.min.css">
        <link rel="stylesheet" href="../../styles/style-panel.css">
    </head>
    <body>
        <jsp:include page="../menu.jsp"/>
        <div class="content">
            <%
                if (session.getAttribute("logged-user-id") == null) {
                    String site = new String("../index.jsp");
                    response.setStatus(response.SC_MOVED_TEMPORARILY);
                    response.setHeader("Location", site);
                } else {
                    if (request.getParameter("logut") != null) {
                        session.setAttribute("logged-user-id", null);
                        session.setAttribute("logged-user-nick", null);
                        session.setAttribute("logged-user-email", null);
                        session.setAttribute("logged-user-level", null);
                        String site = new String("../index.jsp");
                        response.setStatus(response.SC_MOVED_TEMPORARILY);
                        response.setHeader("Location", site);
                    } else if (Integer.valueOf(session.getAttribute("logged-user-level").toString()) < 2) {
                        String site = new String("../index.jsp");
                        response.setStatus(response.SC_MOVED_TEMPORARILY);
                        response.setHeader("Location", site);
                    } else {

                        Database.polacz();
            %>
            <div id="add" class="button-green">Dodaj Seans</div>
            <table id="table" class="display" style="width:100%">
                <thead>
                    <tr>
                        <th>Id</th>
                        <th>Id Filmu</th>
                        <th>Nazwa Filmu</th>
                        <th>Id Wersji</th>
                        <th>Wersja</th>
                        <th>Data</th>
                        <th>Sala</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        ArrayList<Seans> seanse = Database.readSeanse();
                        for (Seans a : seanse) {
                    %>
                    <tr>
                        <td><%=a.getId()%></td>
                        <td><%=a.getIdFilmu()%></td>
                        <td><%=Database.readFilm(a.getIdFilmu()).getTytul()%></td>
                        <td><%=a.getIdWersji()%></td>
                        <td><%=Database.readWersja(a.getIdWersji()).getTekst()%></td>
                        <td><%=a.getData()%></td>
                        <td><%=a.getSala()%></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <%
                        Database.zamknij();
                    }
                }
            %>
            <div id="dialog-add" title="Dodaj Seans">
                <div class='center'>
                    <form action="dodaj.jsp" method="post" accept-charset="UTF-8">
                        Film: <select name='film'>    
                            <%
                                Database.polacz();
                                for (Film f : Database.readFilmy()) {
                                    out.print("<option value=\""+f.getId()+"\">" + f.getTytul() + "</option>");
                                }
                                Database.zamknij();
                            %>
                        </select><br/><br/>
                        Wersja: <select name="wersja"> 
                            <%
                                Database.polacz();
                                for (Wersja w : Database.readWersje()) {
                                    out.print("<option value=\""+w.getId()+"\">" + w.getTekst() + "</option>");
                                }
                                Database.zamknij();
                            %>  
                        </select><br/><br/>
                        <input class='input-center' type="text" name="data" placeholder="Data (YYYY-MM-DD HH:MM:SS)"><br/><br/>
                        Sala: <select name="sala"> 
                            <%
                                Database.polacz();
                                for (Sala s : Database.readSale()) {
                                    out.print("<option value=\""+s.getId()+"\">" + s.getId() + "</option>");
                                }
                                Database.zamknij();
                            %>  
                        </select><br/><br/>
                        <input type='submit' value='Dodaj' class="button-green">
                    </form>
                </div>
            </div>
            <div id="dialog" title="Modyfikuj Seans">
                <div class='center'>
                    <form action="edit.jsp" method="post" accept-charset="UTF-8">
                        Film: <select id="edit-film" name='film'>    
                            <%
                                Database.polacz();
                                for (Film f : Database.readFilmy()) {
                                    out.print("<option value=\""+f.getId()+"\">" + f.getTytul() + "</option>");
                                }
                                Database.zamknij();
                            %>
                        </select><br/><br/>
                        Wersja: <select id="edit-wersja" name="wersja"> 
                            <%
                                Database.polacz();
                                for (Wersja w : Database.readWersje()) {
                                    out.print("<option value=\""+w.getId()+"\">" + w.getTekst() + "</option>");
                                }
                                Database.zamknij();
                            %>  
                        </select><br/><br/>
                        <input class='input-center' id="edit-data" type="text" name="data" placeholder="Data (YYYY-MM-DD HH:MM:SS)"><br/><br/>
                        Sala: <select id="edit-sala" name="sala"> 
                            <%
                                Database.polacz();
                                for (Sala s : Database.readSale()) {
                                    out.print("<option value=\""+s.getId()+"\">" + s.getId() + "</option>");
                                }
                                Database.zamknij();
                            %>  
                        </select><br/><br/>
                        <input id="edit-id" type="hidden" name="id" value="0">
                        <input type='submit' value='Edytuj' class="button-green">
                    </form>
                    <form action="del.jsp" method="post" accept-charset="UTF-8">
                        <input id="del-id" type="hidden" name="id" value="0">
                        <input type='submit' value='Usuń' class="button-red">
                    </form>
                </div>
            </div>
        </div>
        <script src="../../scripts/jquery-3.3.1.min.js"></script>
        <script src="../../scripts/jquery.dataTables.min.js"></script>
        <script src="../../scripts/jquery-ui.min.js"></script>
        <script>
            $(document).ready(function () {
                var table = $('#table').DataTable({
                    "order": [[5, "desc"]],
                    "language": {
                        "url": "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Polish.json"
                    },
                    "columnDefs": [
                        {
                            'targets': 2,
                            'render': function (data, type, full, meta) {
                                return data.length > 100 ? data.substr(0, 97) + '…' : data;
                            }
                        }
                    ]
                });
                $('#table tbody').on('click', 'tr', function () {
                    var data = table.row(this).data();
                    $("#dialog").dialog("open");
                    $("#del-id").val(data[0]);
                    $("#edit-id").val(data[0]);
                    $("#edit-film").val(data[1]);
                    $("#edit-wersja").val(data[3]);
                    $("#edit-data").val(data[5]);
                    $("#edit-sala").val(data[6]);
                });
                $("#dialog").dialog({
                    autoOpen: false,
                    show: {
                        effect: "fade",
                        duration: 400
                    },
                    hide: {
                        effect: "fade",
                        duration: 400
                    }
                });
                $("#dialog-add").dialog({
                    autoOpen: false,
                    show: {
                        effect: "fade",
                        duration: 400
                    },
                    hide: {
                        effect: "fade",
                        duration: 400
                    }
                });
                $("#add").click(function () {
                    $("#dialog-add").dialog("open");
                });
            });
        </script>
    </body>
</html>
