package com.node.edit;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.node.utilities.UtilityFunctionsImpl;

/**
 * Servlet implementation class EditServlet
 */
@WebServlet("/EditServlet")
public class EditServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UtilityFunctionsImpl utility = new UtilityFunctionsImpl();

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public EditServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String nodeId = request.getParameter("nodeID");
		String title = request.getParameter("title");
		String description = request.getParameter("description");
		String[] escapetexts = utility.setEcsapeTitleDesc(title, description);
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager
					.getConnection("jdbc:mysql://localhost:3306/test");
			// Connection con =
			// DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"
			// +"user=orbits&password=orbits");
			// Update the title and desc with new data

			java.sql.PreparedStatement stat1 = con
					.prepareStatement("UPDATE Node SET Title='"
							+ escapetexts[0] + "' , Description='"
							+ escapetexts[1] + "' Where NodeID='" + nodeId
							+ "'");
			stat1.executeUpdate();
			RequestDispatcher dispatcher = request
					.getRequestDispatcher("/DisplayNodesServlet?projectId="+nodeId);
			dispatcher.forward(request, response);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
