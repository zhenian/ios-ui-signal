# iOS UI Signal

### DECLARATION
##### At first, the code is come from [BeeFramewrok](http://www.bee-framework.com/) ([github](https://github.com/gavinkwoe/BeeFramework))which is under MIT License.

### OVERVIEW

#### Problem
Let's see a view structure 

```

ViewController(VC)
    ---- view
        ----view.1
            ----view.1.1
                ----view.1.1.1
                ----view.1.1.2
            ----view.1.2
        ----view.2 

```

When ```view.1.1.2``` recevie the user action, and need to notify vc, what should you do? Creat delegates for view1.1.2, view.1.1, view.1 and VC ? Or use block instand of delegates?

** That two solution are NOT elegant！**

iOS UI Signal is a bester soutions for this problem.

### FEATURE
1. Declare the signals

	in Header file:
	
	```
	   AS_SIGNAL( ACTION ) // a signal named 'ACTION'
	
	```
	in m file
	
	```
	   DEF_SIGNAL( ACTION )
	```

2. Send signal

	```
	// You can send signal when some action occur
	[self sendUISignal:View1.ACTION withObject:nil from:otherView];
	```
3. Hand signal in View or ViewController
	
	```
	- (void)handleUISignal:(BeeUISignal *)signal   {   }
	```
	or
	
	```
	- (void)handleUISignal:(BeeUISignal *)signal   	{	    // Signal which no handle 
	}
	   	- (void)handleUISignal_View1:(BeeUISignal *)signal   	{	    // Signal come from View1		    if ( [signal is:View2.ACTION] )	    {	         // If the signal is ACTION and it come from View1	     }	}
	   	- (void)handleUISignal_View2:(BeeUISignal *)signal   	{	    //  Signal come from View2 	}
	```



