function setup(){
	createCanvas(800,800);
}

function draw(){
	background(0);
	tree(width/2, height, 200, -PI/2, 9);
}

function branch(x,y,l,ang){
	this.x = x;
	this.y = y;
	this.l = l;
	this.a = ang;
	this.show = function(wt){
		xbegin = this.x;
		ybegin = this.y;
		ang    = this.a;
		xend   = xbegin + this.l * cos(ang);
		yend   = ybegin + this.l * sin(ang);
		strokeWeight(wt);
		line(xbegin,ybegin,xend,yend);
	};
}


function tree(x,y,l,ang,level){
	var b = new branch(x,y,l,ang);
	stroke(255);
	strokeWeight(4);
	b.show(exp(level/2.2));
	var xend = b.x + b.l*cos(b.a);
	var yend = b.y + b.l*sin(b.a);
	var addang = -PI+2*PI*(mouseY/height);
	var allang = -PI+2*PI*(mouseX/width );
	if(level>1){
		level -= 1;
		var nl1 = 2*b.l/3 + 0.01*random(b.l);
		var nl2 = 2*b.l/3 + 0.01*random(b.l);
		tree(xend,yend,nl1,b.a+addang+allang,level);
		tree(xend,yend,nl2,b.a-addang+allang,level);
	} else{
		noStroke();
		fill(255,0,0,128);
		ellipse(xend,yend,15,15);
	}
}
