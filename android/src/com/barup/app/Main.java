package com.barup.app; import android.app.Activity; import android.os.Bundle; import android.widget.TextView;
public class Main extends Activity { protected void onCreate(Bundle b){super.onCreate(b); TextView t=new TextView(this); t.setText("barUp"); setContentView(t);} }
