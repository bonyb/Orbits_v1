package com.node.export;

import java.awt.AWTException;
import java.awt.Dimension;
import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class ExportServlet
 */
@WebServlet("/ExportServlet")
public class ExportServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ExportServlet() {
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
		System.out.println("I am in Get");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// get the size
		// Dimension size = Toolkit.getDefaultToolkit().getScreenSize();
		// Dimension size = new Dimension(1000,800);
		// capture the screenshot
		Robot robot;
		try {
			robot = new Robot();
			String offsetX = request.getParameter("offsetX");
			String offsetY = request.getParameter("offsetY");

			// Need to get Browser location

			BufferedImage img = robot.createScreenCapture(new Rectangle(Integer
					.parseInt(offsetX), Integer.parseInt(offsetY) + 150, 1000,
					800));
			// write to a file

			File save_path = new File(
					"/Users/nabamalika_banerjee/Desktop/orbitsScreen.jpg");
			ImageIO.write(img, "JPG", save_path);
		} catch (AWTException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
