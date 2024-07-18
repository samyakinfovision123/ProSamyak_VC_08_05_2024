var selectedList;
var availableList;

function delAttribute(availableOptions, selectedOptions){
	availableList = document.getElementById(availableOptions);
    selectedList = document.getElementById(selectedOptions);
    var selIndex = selectedList.selectedIndex;
    if(selIndex < 0)
        return;
    availableList.appendChild(selectedList.options.item(selIndex));
    selectNone(selectedList,availableList);
    setSize(availableList,selectedList);
}
function addAttribute(availableOptions, selectedOptions){
	availableList = document.getElementById(availableOptions);
    selectedList = document.getElementById(selectedOptions);
    var addIndex = availableList.selectedIndex;
    if(addIndex < 0)
        return;
    selectedList.appendChild(availableList.options.item(addIndex));
    selectNone(selectedList,availableList);
    setSize(selectedList,availableList);
}
function addAttributeMultiple(availableOptions, selectedOptions){
	availableList = document.getElementById(availableOptions);
    selectedList = document.getElementById(selectedOptions);
	var addIndexList = new Array();
	var j=0;
	for(i=0; i<availableList.length; i++){

		if(availableList.item(i).selected)
		{			
			addIndexList[j] = availableList.item(i).index;
			j++;
		}
	}
	
	var count=0;
	
	for(i=0; i<j; i++){
	
		var tempIndex = addIndexList[i];
		tempIndex -= count;
	
		selectedList.appendChild(availableList.options.item(tempIndex));			
		count++;
		
	}
	
	selectNone(selectedList,availableList);
	setSize(selectedList,availableList);
}
function delAttributeMultiple(availableOptions, selectedOptions){
	availableList = document.getElementById(availableOptions);
    selectedList = document.getElementById(selectedOptions);
	var delIndexList = new Array();
	var j=0;
	for(i=0; i<selectedList.length; i++){

		if(selectedList.item(i).selected)
		{			
			delIndexList[j] = selectedList.item(i).index;
			j++;
		}
	}
	
	var count=0;
	
	for(i=0; i<j; i++){
	
		var tempIndex = delIndexList[i];
		tempIndex -= count;
	
		availableList.appendChild(selectedList.options.item(tempIndex));			
		count++;
		
	}
	
	selectNone(selectedList,availableList);
	setSize(selectedList,availableList);
}
function delAll(availableOptions, selectedOptions){
	availableList = document.getElementById(availableOptions);
    selectedList = document.getElementById(selectedOptions);
    var len = selectedList.length -1;
    for(i=0; i<=len; i++){
        availableList.appendChild(selectedList.item(0));
    }
    selectNone(selectedList,availableList);
    setSize(selectedList,availableList);
    
}
function addAll(availableOptions, selectedOptions){
	availableList = document.getElementById(availableOptions);
    selectedList = document.getElementById(selectedOptions);
    var len = availableList.length -1;
    for(i=0; i<=len; i++){
        selectedList.appendChild(availableList.item(0));
    }
    selectNone(selectedList,availableList);
    setSize(selectedList,availableList);
    
}
function selectNone(list1,list2){
    list1.selectedIndex = -1;
    list2.selectedIndex = -1;
    addIndex = -1;
    selIndex = -1;
}
function setSize(list1,list2){
    //list1.size = getSize(list1);
    //list2.size = getSize(list2);
}
function getSize(list){
    /* Mozilla ignores whitespace, IE doesn't - count the elements in the list */
    var len = list.childNodes.length;
    var nsLen = 0;
    //nodeType returns 1 for elements
    for(i=0; i<len; i++){
        if(list.childNodes.item(i).nodeType==1)
            nsLen++;
    }
    if(nsLen<2)
        return 2;
    else
        return nsLen;
}

function selectAll(selectedOptions){
    selectedList = document.getElementById(selectedOptions);
    for(i=0; i<selectedList.length; i++){
       selectedList.item(i).selected=true;
    }
}

