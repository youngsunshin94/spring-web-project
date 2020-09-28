var replyService = (function(){
	
	function add(reply, callback, error) {
		$.ajax({
			url:"/boardProject/replies/new",
			type:'post',
			contentType:"application/json; charset=utf-8",
			data:JSON.stringify(reply),
			success:function(result) {
				if(callback){
					callback(result);
				}
			}
		});
	}
	
	function getList(param, callback, error) {
		
		var bno = param.bno;
		var page = param.page || 1;
		
		$.getJSON("/boardProject/replies/pages/"+bno+"/"+page+".json", function(result){
			if(callback){
				callback(result.list, result.replyCnt);
			}
		});
	}
	
	function get(rno, callback, error) {
		$.getJSON("/boardProject/replies/"+ rno +".json", function(result){
			if(callback){
				callback(result);
			}
		});
	}
	
	function update(reply, callback, error) {
		$.ajax({
			url:"/boardProject/replies/"+reply.rno,
			type:"put",
			contentType:"application/json",
			data:JSON.stringify(reply),
			success:function(result) {
				if(callback){
					callback(result);
				}
			}
		});
	}
	
	function remove(rno, replyer, callback, error) {
		$.ajax({
			url:"/boardProject/replies/"+rno,
			type:'delete',
			data:JSON.stringify({rno:rno,replyer:replyer}),
			contentType:"application/json; charset=utf-8",
			success:function(result){
				if(callback){
					callback(result);
				}
			}
		});
	}
	
	function displayTime(timeValue) {
		var dateObj = new Date(timeValue);
		
		var yy = dateObj.getFullYear();
		var mm = dateObj.getMonth()+1;
		var dd = dateObj.getDate();
		
		return [yy,"/", (mm > 9 ? '' : '0') + mm,"/", (dd > 9 ? '' : '0')+dd].join('');
	}
	
	return {
		add:add,
		getList:getList,
		get:get,
		update:update,
		remove:remove,
		displayTime:displayTime
	}
	
})();