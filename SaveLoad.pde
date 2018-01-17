
void saveToFile () {
  println("Saving");
  _saveData();
}

void _saveData () {
  try {
    FileOutputStream fos = new FileOutputStream(sketchPath("")+"sectors.plop");
    ObjectOutputStream oos = new ObjectOutputStream(fos);
    oos.writeObject(map.sectors);
    fos.close();
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
}

void loadFromFile () {
  Sector[] fromDisk = _loadData();
  map.verts = new Vertex[0];
  map.sectors = new Sector[0];
  for(int i =0 ;i <fromDisk.length;i ++){
    println(i);
    if(i == 0){
      println("setting s1");
     s1 = fromDisk[i]; 
    }
    map.addSector(fromDisk[i]);
    map.addVertices(fromDisk[i].verts);
  }
   println("Loaded");
}


Sector[] _loadData() {
  Sector[] sects = null;
  try {
    FileInputStream fis = new FileInputStream(sketchPath("") +"sectors.plop");
    ObjectInputStream ois = new ObjectInputStream(fis);
    sects = (Sector[]) ois.readObject();
    fis.close();
  } 
  catch (IOException e) {
    e.printStackTrace();
  } 
  catch (ClassNotFoundException e) {
    e.printStackTrace();
  }
  return sects;
}