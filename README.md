# arp-hangers v1.0
a Garage system for Planes/Helis and Light-Aircrafts coded on the gmattmysql.

# Installation

- Put the resource inside your `resources` folder.
- Import `player_aircrafts.sql` in your database. 
- Convert this resource from `arp` to `qb`. It is QBCore ready, I just made this specificly for my framework name.
- Once you have done that, I recommend to ensure it in your `server.cfg`

# Dependencies

This script requires:

- QBCore Framework 
- arp-aircraft

# Issues

- There currently is an issue with storing your aircrafts. For some odd reason, they go to the depot instead of back into the garage. Will be fixed in the future
- The garage system uses crappy gui. This will be updated in the future to use nh-context which you can swap out for qb-menu

