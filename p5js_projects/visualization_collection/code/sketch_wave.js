let c;
let grid = [];
let cols = 30;
let rows = 30;


function setup() {
    createCanvas(400, 400);
    let loc = -PI/10;
    let row_size = height/rows;
    let col_size = width/cols;
    c = new Cell();
    for (let i=0; i<cols; i++){
        grid[i] = [];
        for (let j=0; j<rows; j++){
            grid[i][j] = new Cell(col_size/2+i*col_size,
                row_size/2+j*row_size,row_size/2,
                i*loc+j*loc);
        }
    }
}

function draw() {
    background(220);
    for (let i=0; i<cols; i++){
        for (let j=0; j<rows; j++){
            grid[i][j].update();
            grid[i][j].display();
        }
    }
}

class Cell {
    constructor(x0,y0,r,angle){
        this.r = r;
        this.angle = angle;
        this.x0 = x0;
        this.y0 = y0;
    }
    update(){
        this.x = this.r*cos(this.angle);
        this.y = this.r*sin(this.angle);
        this.angle += 0.05;
    }
    display(){
        // line(this.x0,this.y0,this.x0+this.x,this.y0+this.y);
        ellipse(this.x0+this.x, this.y0+this.y, 5, 5);
    }
}