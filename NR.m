function [x, err, iter, conv] = NR(fns, vars, maxNumberOfIter, eps, x0)
    x=x0;
    J=jacobian(fns,vars); 
    iter=0; conv=1;
    while 1
        if(iter>maxNumberOfIter)
            conv=0;
            err=max(abs(f_trenutni));
            iter=maxNumberOfIter;
            break;
        end
        f_trenutni=evaluateSymMatrix(fns, vars, x);
        if(max(abs(f_trenutni))<eps)
            err=max(abs(f_trenutni));
            break;
        end
        iter=iter+1;
        delta_x=-(evaluateSymMatrix(J, vars, x))\f_trenutni;
        x=x+delta_x;
    end
  
end

 
 