package websocket.chat;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.atomic.AtomicInteger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.catalina.websocket.MessageInbound;
import org.apache.catalina.websocket.StreamInbound;
import org.apache.catalina.websocket.WebSocketServlet;
import org.apache.catalina.websocket.WsOutbound;

/**
 * Servlet implementation class ChatWebSocketServlet
 */
//@WebServlet(value = "/websocket/chat", loadOnStartup = 1)
public class ChatWebSocketServlet extends WebSocketServlet {
	private static final long serialVersionUID = 1L;
       
    //private static final String GUEST_PREFIX = "Guest";

    private final AtomicInteger connectionIds = new AtomicInteger(0);
    private int userId =0;
    private Integer projectId =0;
    private String username ="#";
    private final Set<ChatMessageInbound> connections =
            new CopyOnWriteArraySet<ChatMessageInbound>();

    @Override
    public StreamInbound createWebSocketInbound(String subProtocol,
            HttpServletRequest request) {
     	HttpSession session=request.getSession(true);
     	//System.out.println("Par-"+request.getParameter("pid"));
     	try{
     	this.projectId=Integer.parseInt(request.getParameter("pid"));
     	}catch(NumberFormatException nfe){
     		  return new ChatMessageInbound(this.username,this.projectId.toString());
     	}
    	if(session.getAttribute("userID")!=null){
    		//this.userId=session.getAttribute("userID").toString();
    	}
    	if(session.getAttribute("username")!=null){
    		this.username=session.getAttribute("username").toString();
    	}
        return new ChatMessageInbound(this.username,this.projectId.toString());
    }

    public final class ChatMessageInbound extends MessageInbound {

        private final String nickname;

        public ChatMessageInbound(String id,String prid) {
            this.nickname =  id + "#" + prid;
        }

        @Override
        protected void onOpen(WsOutbound outbound) {
        	// need to know what is added/updated in db
        	//check if same project
        	String person="";
         	try{
         	String nickName=this.nickname;
         	int hashIndex=nickName.indexOf("#");
         	String userId=nickName.substring(0, hashIndex);
         	String projectId=nickName.substring(hashIndex+1, nickName.length());
         	Class.forName("com.mysql.jdbc.Driver");
    		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/test");
//    		Connection con =DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");	
    		//put name in db
    		java.sql.PreparedStatement stat2 = con
			.prepareStatement("INSERT INTO SocketPerson VALUES ('"+ userId + "'," + projectId + ")");
    		stat2.executeUpdate();
    		stat2.close();
    		//check if they belong to the project
    		java.sql.PreparedStatement stat1 = con
    		.prepareStatement("select * from SocketPerson where ProjectID='"+ projectId + "'");
    			ResultSet exists = stat1.executeQuery();
    		
    			while (exists.next()) {
    				String row=exists.getString(1)+"#"+exists.getString(2)+";";
    				person=person.concat(row);
    			}
    			stat1.close();
    			con.close();
         	}catch (ClassNotFoundException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		} catch (SQLException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}
            connections.add(this);
            String message = String.format("* %s %s",
            		person, "has joined.");
            broadcast(message);
        }

        @Override
        protected void onClose(int status) {
        	try{
        		String nickName=this.nickname;
             	int hashIndex=nickName.indexOf("#");
             	String userId=nickName.substring(0, hashIndex);
        	Class.forName("com.mysql.jdbc.Driver");
    		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/test");
//    		Connection con =DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");	
    		//put name in db
    		java.sql.PreparedStatement stat2 = con
			.prepareStatement("DELETE FROM SocketPerson WHERE Person= '"+ userId + "'");
    		stat2.executeUpdate();
    		stat2.close();
    		con.close();
        }catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
            connections.remove(this);
            String message = String.format("* %s %s",
                    nickname, "has left.");
            broadcast(message);
        }

        @Override
        protected void onBinaryMessage(ByteBuffer message) throws IOException {
            throw new UnsupportedOperationException(
                    "Binary message not supported.");
        }

        @Override
        public void onTextMessage(CharBuffer message) throws IOException {
            // Never trust the client
        	//check if pid is the project id
            String filteredMessage = String.format("%s: %s",
                    nickname, CharBuffer.wrap(message));
            broadcast(filteredMessage);
        }
       

        private void broadcast(String message) {
            for (ChatMessageInbound connection : connections) {
                try {
                    CharBuffer buffer = CharBuffer.wrap(message);
                    connection.getWsOutbound().writeTextMessage(buffer);
                } catch (IOException ignore) {
                    // Ignore
                }
            }
        }
    }
	
}
