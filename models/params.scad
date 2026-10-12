// Shared dimensions (mm). Edit here, then re-export STLs.

// Deck
deck_len       = 96;
deck_w         = 34;
deck_t         = 3.0;   // printed decks need to be a bit thicker than wood
wheelbase      = 45;    // distance between the inner truck holes
concave_depth  = 1.5;
kick_angle     = 20;
kick_start     = 34;    // distance from deck center where the kicks begin to bend
kick_bend      = 8;     // length of the curved transition into the kick

// Truck mounting holes (Tech Deck pattern; measure your trucks to confirm)
hole_dx        = 8;     // spacing along the deck
hole_dy        = 5;     // spacing across the deck
deck_hole_d    = 1.8;   // clearance for the Tech Deck screws
plate_hole_d   = 1.4;   // pilot hole so the screws thread straight into the baseplate

// Grip texture
grip           = true;
grip_pitch     = 1.2;
grip_depth     = 0.25;

// Truck
truck_w        = 34;    // outer edge to outer edge of the wheels
kp_angle       = 40;    // kingpin and pivot tilt from vertical
kp_d           = 2.4;   // printed kingpin pin diameter
axle_d         = 2.0;
axle_z         = -8.6;  // axle center below the deck's bottom face
bushing_d      = 4.6;
bushing_h      = 1.5;

// Wheels
wheel_d        = 7.0;
wheel_w        = 4.0;
tire_t         = 0.6;   // TPU 68D tire thickness
wheel_gap      = 0.3;   // clearance between the hanger and the wheel

// Fit tolerances (tune after a test print)
press_fit      = 0.10;  // interference for the kingpin pin and axle caps
spin_fit       = 0.25;  // clearance for the wheel bore
