// This source code is in the public domain.

// Cairo: Animate a Text Counter

import std.stdio: writeln;
import std.conv;
// import std.math;

import gtk.MainWindow;
import gtk.Main;
import gtk.Box;
import gtk.Widget;
import cairo.Context;
import gtk.DrawingArea;
import glib.Timeout;
import gtk.Button;

void main(string[] args) {

	Main.init(args);

	StopwatchWindow w = new StopwatchWindow("SDL test");    
    auto box = new Box(Orientation.VERTICAL, 10);

	auto displayTime = new DisplayTime();

    auto buttonsContainer = new Box(Orientation.HORIZONTAL, 10);
    
    auto startButton = new Button("Start");
    startButton.addOnClicked(delegate void(Button b) { writeln("Start"); });
    buttonsContainer.packStart(startButton, true, true, 0);

    auto pauseButton = new Button("Pause");
    pauseButton.addOnClicked(delegate void(Button b) { writeln("Pause"); }); 
    buttonsContainer.packStart(pauseButton, true, true, 0);

    auto stopButton = new Button("Stop");
    stopButton.addOnClicked(delegate void(Button b) { writeln("Stop"); }); 
    buttonsContainer.packStart(stopButton, true, true, 0);

    auto resetButton = new Button("Reset");
    resetButton.addOnClicked(delegate void(Button b) { writeln("Reset"); }); 
    buttonsContainer.packStart(resetButton, true, true, 0);

    box.packStart(buttonsContainer, false, true, 0);


    box.packStart(displayTime, true, true, 0);

    w.add(box);
    w.showAll();
	Main.run();
}

class StopwatchWindow : MainWindow {
    int width  = 640;
    int height = 360;
    this(string title) {
        super(title);
        this.setSizeRequest(width, height);
        this.addOnDestroy((Widget widget) => Main.quit());
    }
}

class DisplayTime : DrawingArea {
    Timeout timeout;
	int fps = 1000 / 30;
    MonoTime startTime;
    
    this() {
        this.addOnDraw(&onDraw);
    }

    bool onDraw(Scoped!Context context, Widget w)
    {
        if(timeout is null)
        {
            timeout = new Timeout(fps, &onFrameElapsed, false);
        }
        
        context.selectFontFace("Helvetica", CairoFontSlant.NORMAL, CairoFontWeight.NORMAL);
        context.setFontSize(65);
        context.setSourceRgb(0.0, 0.0, 0.0);
        context.moveTo(280, 170);
        
        auto 
        
        context.showText(number.to!string());
        number++;

        return(true);
        
    }

    bool onFrameElapsed()
    {
        queueDraw();
        
        return(true);
        
    }

}
