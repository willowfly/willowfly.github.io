// a simple procedural animation technique 
let circles = [];
let num = 50;
let rad = 20;
function setup() {
    createCanvas(1500, 800);
    for(i = 0; i<num; i++) {
        c = new Circle(i*rad,height/2,rad);
        circles.push(c);
    }    
}

function draw() {
    background(0);
    for(i = 0; i<num; i++) {
        if(i===0){
            circles[i].follow_mouse()
        } else {
            circles[i].distance_constraint(circles[i-1]);
        }
        circles[i].display();
    } 
}

class Circle {
    constructor(x,y,r) {
        this.x = x;
        this.y = y;
        this.r = r;
    }
    follow_mouse() {
        this.x = mouseX;
        this.y = mouseY;
    }
    distance_constraint(head_circle) {
        let X = head_circle.x;
        let Y = head_circle.y;
        let distance = dist(this.x,this.y,X,Y);
        let uni_x = (this.x-X)/distance;
        let uni_y = (this.y-Y)/distance;
        this.x = X + uni_x*this.r;
        this.y = Y + uni_y*this.r;
    }
    display() {
        fill(0,127,127); stroke(255);
        ellipse(this.x, this.y, this.r, this.r);
    }
}