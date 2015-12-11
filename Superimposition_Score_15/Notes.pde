/*
0 - trill
1 - tongueslap
2 - multi
3-flz

10 - bartok
11 - harmonic


Make Score
Rescale Multiphonic
Rescale Harmonic
Duplicate/Redraw for unisons

Yellow=open pitch
Fushia=Messian Mode 3
Orange=Tetrachord

Solid=open range
Dotted=Compressed Range w/Outliers
Dashed=Random Range
Dot-Dash=Up & Down

Harp: trill, bartokpizz, multiphonic, harmonic
Sax: trill, flz, tongueslap, multiphonic



Fill Switch with appropriate text instructions and score instructions
Make a clear all

for goto
  move cursor to 1 bar before system start
  Run through entire score up to desired number
  set current score counter to number
  set cursor to go








PACE THE SCORE WITH AUTO FLIP

FIGURE OUT HOW TO SUGGEST OTHER CHANGES



FIX SCORING ORDER BY PUTTING IT IN THE CORRECT CASE NUMBER
  PACE SCORE
  
SPACE OUT SOME RHYTHMS, ADD SYSTEM NUMBERS AND MAKE NEW VIDEO

SORT OUT ELECTRONICS
  
  

Make rehearsal score
put score number up
be able to go to a score number by osc
control pace of flip, once every 2 pages

FIX MULTIPHONIC Y LOCATION

GO THROUGH ARTICULATION FUNCTION AND ADAPT FOR INDIVIDUAL RHYTHMS

MOVE SVGDISPLAY INTO RHYTHMMKR CLASS
FIX CONCURRENT ERROR
AUTO SCORE IN PROCESSING WITH PAUSE STATE TRIGGER

FIX MULTIPHONIC POSITION
UNISONS
  Make a display only class

Create counter to advance sections
Remove Articulations


Make video of first section, send pitchsets and video instructions, atriculation legend


way to display same rhythms and articulations on more than one track - clone class?

Fix Sustained overflow nullpointer
Concurrent drawing of svgs? error
Have a back up master score


LIVE ELECTRONICS SCORE
SAME AS INSTRUMENTALISTS, MORE EFFECTS/SYNTHSIS BECOMES AVAILABLE OR CERTIAN ONES BECOME AVAILABLE
FOOTPEDALS FOR EFFECTS, 2 BUTTON FOR SYNTHESIS, EFFECTS/SYNTHESIS CHANGE CONTROLLED BY SCORE

MAKE A SUPERIMPOSITION ON:
  medium-sparce 9&2
  medium: rh 7, 8
  dense: rh 4&5;

Make 3 more med-dense rhythm sets


fix grab next available index of svg set
make flz svg smaller


fix make sustaining notes - maybe just a latency issue?
Way to add or remove from exsisting articulations
add a cluster tremelo articulation


CREATE 2 OR 3 RHYTHMS - DENSE/UNISON/SPARCE/LOTS SUSTAINED
CREATE A WAY TO SUPERIMPOSE DIFFERENT THINGS
  RAW RHYTHMS
  PITCHES
  PITCH SETS
  DYNAMICS
  ARTICULATIONS
MAKE VIDEOS, SEND PITCH SETS AND INSTRUCTIONS


Create Articulations Function
  Tie to pitches
  Detect if near top/bottom and swap side of pitch
  If too close to both, ie big pitch range, then place above measure line
  args: num of articulations, set of articulations to use
  Way to add or remove from exsisting articulations
  Way for trill et al to be only on sustained notes


Fix SVGs in Inkscape to be just the right size and color

Articulations
  move over svg display code
  Make like pitch set where you choose between articulations and num of articulations
  Attach sustained ones to sustained notes



Decres
Hairpins
sf
Pitch Class - incorporate into pitch range colors - yellow, fuchia, green, turquoise, orange 
Articulations
Score Generator
Live Electronics Rig
Mic Set up, soundcard etc
Monitor setup
Documentation: Recording & capturing score



Dynamics reflected in the pitches by fattness of stroke
Pitch Set as colored rect at top of track

Remove dynamics

redo dynamics make partial independant


Make dynamics array - set up first & last points and control points, fill rest w/zero
Increment: 0.04, 7 incs total ppp, pp, p, mp/mf, f, ff, fff
Initial dynamic 1-7
  Scenarios
  
    Jumps, num jumps, min num of inc, max num of inc, direction or flip
      Constrain so that jumps aren't made within first or last beat of track
      If can't make that many incs in one direction go the other direction, (if flip), if can't do that either go to max in that direction
    
    Crescendo/Decrescendo
      number of cres, decres, hairpins; min dynamic, max dynamic, choose within min/max or always go from min to max
      
      get the start and end partials of each crescendo
      make & fill the array
      
      
      
      Stepped crescendo/decresendo
      
      sfortsandi
      
      
PITCH CLASSES
  Num of changes, available pitch classes, initial pitch class
  Find colors
  Open, messian 1, tonerow, tetrachord, messiaen 2, cluster
      





Make Loops

clusters w/outliers


Maybe add in rangemin/max for pitch class

fix sustained notes
remove pitches


Make Additional lines per rhythm that cover part of the rhythm line for the pitch
normalize, and then figure a way to plug values into the line and rect functions
range width, tessatura, use the center of the line and draw the range, constrain to make sure it doesn't go above/below the track
1-10 for the tessatura
line at top underneath everything for pitch class
Have mostly open pitch, and make patterns to impose occationally - alternate high/low; scale up/down; clusters of repeated notes; random
Have chord change patterns as well, density based - 1 change, 2 changes, 3 changes, 
combine dynamics & pitch set


Pitch Class Method
  Swaths of transparent color
  Catagories - algorithms - Make by staff so each staff will have a characteristic
    Range width
    Tessatura
    Direction
    Chord Change

Make a all pitch with different densities of chord change
Make several small range width that jump around with different tessatura
Going up and down linearly

For this piece:
2 messiaen modes
A 12 tone row
0124? tetrachord
open pitch

DYNAMICS
  Hairpins - amount, density
  General Dynamic & frequency of changes
  
ARTICULATIONS

FORM 5MIN(MAIN, DENSE) - 2MIN(SPARCE) - 3MIN(MAIN,DENSE) - 2MIN(LOTS OF ELECTRONICS) - 2MIN(MAIN,DENSE)



Sustained Notes
Pauses In The Action
Articulations
Pitch/PitchSet/Dynamic Worm


Make a tup3 function - triple nested tuplets
Make 30 tuplets
Make 20 rhythm sets

Make 10 algorithms to run on all 50 sets
1,1,2,3,5,8,13
1,2,3,2,1
1,2,1,5,1,7,3
7,3,2,7
9,1,1,3,1,2,5,1,7
2,3,1
5,3,7
1,3
2,2,4,6,6,8
3,3,5,5,1,7,7

Draw a thickish line like cage aria for tessitura/dynamics/pitchset

sustained notes

choose a few articulations each
tongueslap, trill, fluttertongue, multiphonics
bartok pizz, mute, trill, ??

way to display live electronics; live electronics will be chosen at random?
way of introducing space

Way of randomly choosing rhythms and flagging the ones I like

Make tuplets & rhythm sets in processing
Make rhythms (extracted from rhythm sets) in sc


All algorhythms triggered from supercollier side
Build rhythm trees within processing
Have sets of possibilities in supercollider
Trigger in Processing - @start+10px and half+2beats

I control live:
  Pitch Set Changes
  Effects
  Sample Triggers
  Possibly which sets of notation and how quickly it goes through


Simplify so only a drawing program


Make it so it updates first half 3/4 of the way and 2nd half 1/4 of the way

//make sets of tuplets
//way of arranging which partials to display
//algorthim of choosing various tuplets and partials
//arrays of x values
// random choosing of the array with beat range 
//find min and max partials, then random for those partials
//classify, oscify

//make a bunch of tuplets
//function to grab tuplet, give range and algorithm, and store in array
//trigger to draw


FUTURE VERSIONS
Server to calculate and hold all notation data
Client to draw
  Can store data precise pixel/drawing data from server
  
A composition that uses random loops for choosing from and synced unisons and a countdown to unison
  Meet ups for duets and trios etc - simple controller for this
    Maybe LEDs light up for ensemble requests, maybe even a number display and you press a button to accept, leds attached to a clip with a photo









*/