import std.stdio: writeln;
import std.conv;

import gtk.Box;
import gtk.MainWindow;
import gtk.Main;
import gtk.Widget;
import cairo.Context;
import gtk.DrawingArea;
import gtk.Button;

void main(string[] args) {
    import gtk.Notebook;
    import gtk.Label;

	Main.init(args);

    StopwatchWindow w = new StopwatchWindow("Stopwatch");    

    auto tabContainer = new Notebook();
    tabContainer.setTabPos(PositionType.TOP);
    
    Label stopWatchTabLabel = new Label("Stopwatch");
    auto stopWatchBox = buildStopWatchTab();
    tabContainer.appendPage(stopWatchBox, stopWatchTabLabel);

    w.add(tabContainer);
    w.showAll();
	Main.run();
}

Box buildRoutineTab() {
    import gtk.Button;

    auto box = new Box(Orientation.VERTICAL, 10);

	auto displayTime = new DisplayTime();
    auto buttonsContainer = new Box(Orientation.HORIZONTAL, 10);
    
    auto startButton = new Button("Start");
    startButton.addOnClicked(delegate void(Button b) { displayTime.toggleTimer(startButton); });
    buttonsContainer.packStart(startButton, true, true, 0);

    auto resetButton = new Button("Reset");
    resetButton.addOnClicked(delegate void(Button b) { displayTime.reset(startButton); }); 
    buttonsContainer.packStart(resetButton, true, true, 0);

    box.packStart(buttonsContainer, false, true, 0);

    box.packStart(displayTime, true, true, 0);
    return box;    
}

Box buildStopWatchTab() {
    import gtk.Button;

    auto box = new Box(Orientation.VERTICAL, 10);

	auto displayTime = new DisplayTime();
    auto buttonsContainer = new Box(Orientation.HORIZONTAL, 10);
    
    auto startButton = new Button("Start");
    startButton.addOnClicked(delegate void(Button b) { displayTime.toggleTimer(startButton); });
    buttonsContainer.packStart(startButton, true, true, 0);

    auto resetButton = new Button("Reset");
    resetButton.addOnClicked(delegate void(Button b) { displayTime.reset(startButton); }); 
    buttonsContainer.packStart(resetButton, true, true, 0);

    box.packStart(buttonsContainer, false, true, 0);

    box.packStart(displayTime, true, true, 0);
    return box;
}

class StopwatchWindow : MainWindow {
    int width  = 640;
    int height = 480;
    this(string title) {
        super(title);
        this.setSizeRequest(width, height);
        this.addOnDestroy((Widget w) => Main.quit());
    }
}

class DisplayTime : DrawingArea {
    import std.datetime: Duration;
    import std.datetime.stopwatch: StopWatch, AutoStart;
    import glib.Timeout;

    bool paused;
    Timeout timeout;
	int fps = 1000 / 30;
    StopWatch timer;
    
    this() {
        this.addOnDraw(&onDraw);
        this.timer = StopWatch(AutoStart.no);
    }

    void toggleTimer(Button timerButton) {
        if (this.timer.running) {
            debug writeln("Stop");
            this.paused = true;
            this.timer.stop();
            timerButton.setLabel("Restart");
        } else {
            this.paused = false;
            debug writeln("Restarting"); 
            this.timer.start();
            timerButton.setLabel("Pause");
        }
    }

    void reset(Button startButton) {
        debug writeln("Reset"); 
        if (this.timer.running()) {
            this.timer.stop();
        }
        this.timer.reset();
        startButton.setLabel("Start");
    }

    bool onDraw(Scoped!Context context, Widget w)
    {
        import std.conv: to;
        // import std.datetime.systime: Clock, SysTime, Duration;

        if(timeout is null)
        {
            timeout = new Timeout(fps, &onFrameElapsed, false);
        }
        
        context.selectFontFace("Helvetica", CairoFontSlant.NORMAL, CairoFontWeight.NORMAL);
        context.setFontSize(65);
        context.setSourceRgb(0.0, 0.0, 0.0);

        GtkAllocation allocation;
        int baseline;
        this.getAllocatedSize(allocation, baseline);
        context.moveTo(30, allocation.height/2);
        int seconds;
        short miliseconds;
        auto elapsed_so_far = this.timer.peek();
        elapsed_so_far.split!("seconds", "msecs")(seconds, miliseconds);
        context.showText(seconds.to!string ~ ":" ~ miliseconds.to!string);
        return(true);
    }

    bool onFrameElapsed()
    {
        queueDraw();
        
        return(true);
        
    }

}
