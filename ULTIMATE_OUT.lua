-- Lua script to output data and functions of all dataset in fityk session  

-- Output folder name
folder_out =os.getenv("HOME").."/Desktop/Temp_fit/"

for i=0, F:get_dataset_count()-1 do
    -- get function components of ith dataset    
    f=F:get_components(i)   
    -- create string for function components 
    s_func =""
    for n=0, #f-1 do s_func = s_func .."F[" .. n .. "](x), "  end
    

    title = F:get_info("title",i)
    -- create string to input in fityk to output data and function columns in format x , y, F[0], ..., F[n], Ftot   
    s ="@" .. i ..  ": print all:x ,y," .. s_func .. " F(x) >'" .. folder_out .. title ..".dat'"   
    
    -- create string to output peak positions
    s2 ="@" .. i .. ": info peaks_err >'".. folder_out .. title .. ".peaks'"
    -- execute command in s
    F:execute(s)

    if #f > 0 then
        F:set_throws(false)
        F:execute(s2)
        if F:last_error()~="" then
            s2 ="@" .. i .. ": info peaks >'".. folder_out .. title .. ".peaks'"
            F:execute(s2)
        end


    end

end



