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
     	System.out.println("Par-"+request.getParameter("pid"));
     	try{
     	this.projectId=Integer.parseInt(request.getParameter("pid"));
     	}catch(NumberFormatException nfe){
     		  return new ChatMessageInbound(this.username,this.projectId.toString());
     	}
    	if(session.getAttribute("userID")!=null){
    		this.userId=Integer.parseInt(session.getAttribute("userID").toString());
    	}
     	//check if same project
     	try{
     	Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/test");
//		Connection con =DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");	
		//check if they belong ot the project
		java.sql.PreparedStatement stat1 = con
		.prepareStatement("select PersonID from PersonTreeCon where PersonID='"
				+ this.userId + "' and ProjectID='" + this.projectId + "'");
			ResultSet exists = stat1.executeQuery();
			while (exists.next()) {
			this.userId = Integer.parseInt(exists.getString(1));
			}
		if(this.userId!=0){
     	if(session.getAttribute("username")!=null){
    		this.username=session.getAttribute("username").toString();
    	}
			}
     	}catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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
        	
            connections.add(this);
            String message = String.format("* %s %s",
                    nickname, "has joined.");
            broadcast(message);
        }

        @Override
        protected void onClose(int status) {
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
